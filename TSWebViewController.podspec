#
#  Be sure to run `pod spec lint TSWebViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "TSWebViewController"
  s.version      = "0.0.1"
  s.summary      = "this is WKwebview"

  s.description  = <<-DESC
                  封装了WKwebview, 包括进度条，JS调用Native方法，Native调用JS方法
                   DESC
  s.platform     = :ios, "8.0"
  s.homepage     = "https://www.jianshu.com/u/8a7102c0b777"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "yuchenH" => "huangyuchen@caiqr.com" }
 
  s.source       = { :git => "http://gitlab.caiqr.com/ios_module/TSWebViewController.git", :tag => s.version }

  s.source_files  = "TSWebViewController/code"

  s.resources = "TSWebViewController/code/TSWebViewController.bundle"

  s.framework  = "UIKit","WebKit"

  s.swift_version = '4.0'

  s.requires_arc = true
end

