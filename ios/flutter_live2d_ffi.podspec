#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_live2d_ffi.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_live2d_ffi'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for Live2D with FFI'
  s.description      = 'A Flutter plugin to integrate Live2D using FFI'
  s.homepage         = 'https://github.com/amaiichigopurin/flutter_live2d_ffi/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Glitch9' => 'munchkin@glitch9.dev' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  # Live2D 정적 라이브러리 (.a) 추가
  s.vendored_libraries = 'Libs/libFlutterLive2D.a' #만약 ios/Libs 폴더 안에 있다면, 경로를 ios/Libs/libFlutterLive2D.a로 변경해야 할 수도 있음

  # OpenGL 및 기타 필요한 라이브러리 연결
  s.frameworks = 'OpenGLES', 'QuartzCore' #Live2D가 OpenGLES 기반이라면 Metal은 필요 없음
  s.libraries = 'c++', 'z'
  # c++, z 외에 bz2 또는 stdc++ 등이 필요할 수도 있음 (Live2D SDK 문서 확인 필요)
  # 일부 빌드 오류 발생 시 s.libraries = 'c++', 'z', 'bz2' 추가 고려

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_live2d_ffi_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
