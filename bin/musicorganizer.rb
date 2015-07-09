#! /usr/bin/env ruby

require_relative '../lib/musicorganizer'

opt = {}
opt[:fmt] = ARGV[1] if ARGV[1]

mo = MusicOrganizer.new ARGV[0], **opt
mo.run!
