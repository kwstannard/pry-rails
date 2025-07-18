# encoding: UTF-8
# frozen_string_literal: true

require 'spec_helper'
require 'open3'

describe 'Rails console post -- arguments' do
  describe 'containing "--simple-prompt"' do
    # Readline outputs differently after 3.2. Skipping since 3.2 is near EOL.
    break if RUBY_VERSION < "3.3"
    it 'triggers the simple prompt' do
      prompt = nil
      simple_prompt = "\e[0G\e[?25l\e[1G\e[K\e[1G\e[0m>> \e[0m\e[?25h\e[4G\e[?25l\e[1G\e[K\e[?25h\e[1G>> \r\n"

      Open3.popen2('spec/dummy/bin/rails console -- --simple-prompt') do |i,o|
        i.close
        prompt = o.readlines[1]
      end

      assert_equal prompt, simple_prompt
    end
  end

  describe 'containing "--noprompt"' do
    # Readline outputs differently after 3.2. Skipping since 3.2 is near EOL.
    break if RUBY_VERSION < "3.3"
    it 'triggers the "" prompt' do
      prompt = nil
      noprompt = "\e[0G\e[?25l\e[1G\e[K\e[?25h\e[1G\e[?25l\e[?25h\e[1G \r\n"

      Open3.popen2('spec/dummy/bin/rails console -- --noprompt') do |i,o|
        i.close
        prompt = o.readlines[1]
      end

      assert_equal prompt, noprompt
    end
  end

  describe 'containing "-e puts(1234)"' do
    it 'prints 1234' do
      skip("-e not working yet")
      out = nil

      Open3.popen2('spec/dummy/bin/rails console -- -e "puts(1234)"') do |i,o|
        i.close
        out = o.readlines[1]
      end

      assert_equal out, '1234'
    end
  end
end
