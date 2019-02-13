Pod::Spec.new do |s|
  s.name         = "Logger"
  s.version      = "1.0"
  s.authors      = "Linus Oleander"
  s.homepage     = "https://github.com/oleander/logger-swift"
  s.summary      = "Swift log library"
  s.description  = s.summary + "."
  s.source       = {
    git: "https://github.com/oleander/logger-swift.git",
    tag: s.version
  }

  s.license      = { type: "MIT" }

  s.swift_version = "4.2"
  s.source_files = "Logger/**/*.swift"

  s.test_spec "Tests" do |test_spec|
    test_spec.source_files = "LoggerTests/*.swift*"
    test_spec.dependency "Nimble" #, "~> 7.0.2"
    test_spec.dependency "Quick" #, "~> 1.2.0"
  end

  s.dependency "RainbowSwift"
end
