/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#include "LAppLive2DManager.hpp"
#include <string.h>
#include <stdlib.h>
#include <GLES2/gl2.h>
#include <Rendering/CubismRenderer.hpp>
#include "LAppPal.hpp"
#include "LAppDefine.hpp"
#include "LAppDelegate.hpp"
#include "LAppModel.hpp"
#include "LAppView.hpp"
#include "JniBridgeC.hpp"

using namespace Csm;
using namespace LAppDefine;

namespace {
    LAppLive2DManager* s_instance = NULL;

    void BeganMotion(ACubismMotion* self)
    {
        LAppPal::PrintLogLn("Motion Began: %x", self);
    }

    void FinishedMotion(ACubismMotion* self)
    {
        LAppPal::PrintLogLn("Motion Finished: %x", self);
    }

    int CompareCsmString(const void* a, const void* b)
    {
        return strcmp(reinterpret_cast<const Csm::csmString*>(a)->GetRawString(),
            reinterpret_cast<const Csm::csmString*>(b)->GetRawString());
    }
}

LAppLive2DManager* LAppLive2DManager::GetInstance()
{
    if (s_instance == NULL)
    {
        s_instance = new LAppLive2DManager();
    }

    return s_instance;
}

void LAppLive2DManager::ReleaseInstance()
{
    if (s_instance != NULL)
    {
        delete s_instance;
    }

    s_instance = NULL;
}

LAppLive2DManager::LAppLive2DManager()
    : _viewMatrix(NULL)
{
    _viewMatrix = new CubismMatrix44();
    SetUpModel();

    ChangeScene(LAppDelegate::GetInstance()->GetSceneIndex());
}

LAppLive2DManager::~LAppLive2DManager()
{
    ReleaseAllModel();
    delete _viewMatrix;
}

// 내가 Flutter에서 모델 로드하기 위해 추가한 코드 
// void LAppLive2DManager::LoadModel(const std::string& modelPath, const std::string& modelJson) {
//     ReleaseAllModel(); // 기존 모델 삭제

//     _models.PushBack(new LAppModel()); // 새 모델 추가
//     _models[0]->LoadAssets(modelPath.c_str(), modelJson.c_str()); // 모델 로드
// }
void LAppLive2DManager::LoadModel(const std::string& modelPath) {
    ReleaseAllModel(); // 기존 모델 삭제

    // 모델 JSON 파일 경로 자동 생성
    std::string modelJson = modelPath + "/" + modelPath.substr(modelPath.find_last_of('/') + 1) + ".model3.json";

    // 새로운 모델 로드
    _models.PushBack(new LAppModel());
    _models[0]->LoadAssets(modelPath.c_str(), modelJson.c_str());
}
// 추가 끝  

void LAppLive2DManager::ReleaseAllModel()
{
    for (csmUint32 i = 0; i < _models.GetSize(); i++)
    {
        delete _models[i];
    }

    _models.Clear();
}

void LAppLive2DManager::SetUpModel()
{
    const char MODEL3_JSON[] = u8".model3.json";
    _modelDir.Clear();
    Csm::csmVector<Csm::csmString> root = JniBridgeC::GetAssetList("");
    for (size_t i = 0; i < root.GetSize(); i++)
    {
        Csm::csmString target(root[i]);
        target.Append(MODEL3_JSON, sizeof(MODEL3_JSON) - 1);
        Csm::csmVector<Csm::csmString> sub = JniBridgeC::GetAssetList(root[i].GetRawString());
        for (size_t j = 0; j < sub.GetSize(); j++)
        {
            if (target == sub[j])
            {
                _modelDir.PushBack(root[i]);
                break;
            }
        }
    }
    qsort(_modelDir.GetPtr(), _modelDir.GetSize(), sizeof(csmString), CompareCsmString);
}

LAppModel* LAppLive2DManager::GetModel(csmUint32 no) const
{
    if (no < _models.GetSize())
    {
        return _models[no];
    }

    return NULL;
}

void LAppLive2DManager::OnDrag(csmFloat32 x, csmFloat32 y) const
{
    for (csmUint32 i = 0; i < _models.GetSize(); i++)
    {
        LAppModel* model = GetModel(i);

        model->SetDragging(x, y);
    }
}

void LAppLive2DManager::OnTap(csmFloat32 x, csmFloat32 y)
{
    if (DebugLogEnable)
    {
        LAppPal::PrintLogLn("[APP]tap point: {x:%.2f y:%.2f}", x, y);
    }

    for (csmUint32 i = 0; i < _models.GetSize(); i++)
    {
        if (_models[i]->HitTest(HitAreaNameHead, x, y))
        {
            if (DebugLogEnable)
            {
                LAppPal::PrintLogLn("[APP]hit area: [%s]", HitAreaNameHead);
            }
            _models[i]->SetRandomExpression();
        }
        else if (_models[i]->HitTest(HitAreaNameBody, x, y))
        {
            if (DebugLogEnable)
            {
                LAppPal::PrintLogLn("[APP]hit area: [%s]", HitAreaNameBody);
            }
            _models[i]->StartRandomMotion(MotionGroupTapBody, PriorityNormal, FinishedMotion, BeganMotion);
        }
    }
}

void LAppLive2DManager::OnUpdate() const
{
    int width = LAppDelegate::GetInstance()->GetWindowWidth();
    int height = LAppDelegate::GetInstance()->GetWindowHeight();

    csmUint32 modelCount = _models.GetSize();
    for (csmUint32 i = 0; i < modelCount; ++i)
    {
        CubismMatrix44 projection;
        LAppModel* model = GetModel(i);

        if (model->GetModel() == NULL)
        {
            LAppPal::PrintLogLn("Failed to model->GetModel().");
            continue;
        }

        if (model->GetModel()->GetCanvasWidth() > 1.0f && width < height)
        {
            // 横に長いモデルを縦長ウィンドウに表示する際モデルの横サイズでscaleを算出する
            model->GetModelMatrix()->SetWidth(2.0f);
            projection.Scale(1.0f, static_cast<float>(width) / static_cast<float>(height));
        }
        else
        {
            projection.Scale(static_cast<float>(height) / static_cast<float>(width), 1.0f);
        }

        // 必要があればここで乗算
        if (_viewMatrix != NULL)
        {
            projection.MultiplyByMatrix(_viewMatrix);
        }

        // モデル1体描画前コール
        LAppDelegate::GetInstance()->GetView()->PreModelDraw(*model);

        model->Update();
        model->Draw(projection);///< 参照渡しなのでprojectionは変質する

        // モデル1体描画後コール
        LAppDelegate::GetInstance()->GetView()->PostModelDraw(*model);
    }
}

void LAppLive2DManager::NextScene()
{
    csmInt32 no = (LAppDelegate::GetInstance()->GetSceneIndex() + 1) % _modelDir.GetSize();
    ChangeScene(no);
}

void LAppLive2DManager::ChangeScene(Csm::csmInt32 index)
{
    LAppDelegate::GetInstance()->SetSceneIndex(index);
    if (DebugLogEnable)
    {
        LAppPal::PrintLogLn("[APP]model index: %d", index);
    }

    // model3.jsonのパスを決定する.
    // ディレクトリ名とmodel3.jsonの名前を一致していることが条件
    csmString modelPath(ResourcesPath);
    modelPath += _modelDir[index] + "/";
    csmString modelJsonName(_modelDir[index]);
    modelJsonName += ".model3.json";

    ReleaseAllModel();
    _models.PushBack(new LAppModel());
    _models[0]->LoadAssets(modelPath.GetRawString(), modelJsonName.GetRawString());

    /*
     * モデル半透明表示を行うサンプルを提示する。
     * ここでUSE_RENDER_TARGET、USE_MODEL_RENDER_TARGETが定義されている場合
     * 別のレンダリングターゲットにモデルを描画し、描画結果をテクスチャとして別のスプライトに張り付ける。
     */
    {
#if defined(USE_RENDER_TARGET)
        // LAppViewの持つターゲットに描画を行う場合、こちらを選択
        LAppView::SelectTarget useRenderTarget = LAppView::SelectTarget_ViewFrameBuffer;
#elif defined(USE_MODEL_RENDER_TARGET)
        // 各LAppModelの持つターゲットに描画を行う場合、こちらを選択
        LAppView::SelectTarget useRenderTarget = LAppView::SelectTarget_ModelFrameBuffer;
#else
        // デフォルトのメインフレームバッファへレンダリングする(通常)
        LAppView::SelectTarget useRenderTarget = LAppView::SelectTarget_None;
#endif

#if defined(USE_RENDER_TARGET) || defined(USE_MODEL_RENDER_TARGET)
        // モデル個別にαを付けるサンプルとして、もう1体モデルを作成し、少し位置をずらす
        _models.PushBack(new LAppModel());
        _models[1]->LoadAssets(modelPath.GetRawString(), modelJsonName.GetRawString());
        _models[1]->GetModelMatrix()->TranslateX(0.2f);
#endif

        LAppDelegate::GetInstance()->GetView()->SwitchRenderingTarget(useRenderTarget);

        // 別レンダリング先を選択した際の背景クリア色
        float clearColor[3] = { 0.0f, 0.0f, 0.0f };
        LAppDelegate::GetInstance()->GetView()->SetRenderTargetClearColor(clearColor[0], clearColor[1], clearColor[2]);
    }
}

csmUint32 LAppLive2DManager::GetModelNum() const
{
    return _models.GetSize();
}

void LAppLive2DManager::SetViewMatrix(CubismMatrix44* m)
{
    for (int i = 0; i < 16; i++) {
        _viewMatrix->GetArray()[i] = m->GetArray()[i];
    }
}

