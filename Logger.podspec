Pod::Spec.new do |s|
  s.name         = "Logger"
  s.version      = "1.2"
  s.authors      = "Linus Oleander"
  s.homepage     = "https://github.com/oleander/logger-swift"
  s.summary      = "Swift log library"
  s.description  = s.summary + "."
  s.source       = {
    git: "https://github.com/oleander/logger-swift.git",
    tag: s.version
  }

  s.license      = { type: "MIT", file: "LICENSE" }
  s.osx.deployment_target = "10.10"

  s.swift_version = "4.2"
  s.static_framework = true
  s.source_files = "Sources/Logger/**/*.swift"

  s.test_spec "LoggerTests" do |test_spec|
    test_spec.source_files = "Tests/LoggerTests/*.swift"
    test_spec.dependency "Nimble", "~> 7.3.4"
    test_spec.dependency "Quick", "~> 1.2.0"
  end

  s.dependency "RainbowSwift", "~> 3.1.4"
end
