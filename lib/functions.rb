# frozen_string_literal: true

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'find'
require 'gatherer'

PROBE_EXT_PATTERN = /\.scythe_probe$/.freeze
PROBE_EXT = '.scythe_probe'

def probe_env_var
  ENV['SCYTHE_PROBE_DIR']
end

def probe_dir
  File.expand_path(probe_env_var)
end

def probe_file_name(marker)
  File.join(probe_dir, marker + PROBE_EXT)
end

def file_names(file_spec)
  Find.find(File.expand_path(file_spec))
end

def markers(fn)
  Gatherer.new(IO.read(fn)).markers
rescue StandardError
  []
end

def make_file(fn)
  File.open(fn, 'w') { |f| f << Time.now.to_i }
end

def record_probe(marker)
  fn = probe_file_name(marker)
  make_file(fn) unless File.exist?(fn)
end

def get_probe(file_name)
  Probe.new(File.basename(file_name, '.*'),
            File.mtime(file_name).to_i,
            File.readlines(file_name).first.to_i)
end

def get_probes(dir)
  file_names(dir).grep(PROBE_EXT_PATTERN)
                 .map { |fn| get_probe(fn) }
end

def delete_probe(marker)
  File.delete(probe_file_name(marker))
end

def reporting_interval(text_rep)
  return :seconds if text_rep == 'secs'
  return :hours if text_rep == 'hours'
  return :days if text_rep == 'days'

  :days
end
