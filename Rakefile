# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require "motion/project/template/ios"

begin
  require "bundler"
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.name = "cast"
  app.frameworks += ["MediaAccessibility", "CoreText"]
  app.vendor_project("vendor/GoogleCast.framework", :static, products: ["GoogleCast"], headers_dir: "Headers")
end
