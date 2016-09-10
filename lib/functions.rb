
$:.unshift File.dirname(__FILE__)

require 'find'

RUBY_MARKER_PATTERN = /scythe_probe\s*\(\s*\"(\w+)\"\s*\)/
MARKER_DIR = File.expand_path(".") 

def file_names file_spec
  Find.find(File.expand_path(file_spec))
end

def markers fn
  IO.read(fn).scan(RUBY_MARKER_PATTERN).flatten
rescue
  []
end

def make_file fn
  File.open(fn, "w") {|f|} 
end

def record_marker marker_name
  marker_fn = File.join(MARKER_DIR, marker_name + ".scythe_marker")
  make_file(marker_fn) unless File.exist?(marker_fn)
end


