# encoding: UTF-8

require 'spec_helper'
require 'logger'

if (Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR >= 1) ||
    Rails::VERSION::MAJOR >= 6
  require 'rails/command'
  require 'rails/commands/console/console_command'
else
  require 'rails/commands/console'
end

describe PryRails::Railtie do
  it 'should start Pry instead of IRB and make the helpers available' do
    output = mock_pry('pry-version', "exit")
    _(output).must_match /Pry version/

    %w(app helper reload!).each do |helper|
      _(TOPLEVEL_BINDING.eval("respond_to?(:#{helper}, true)")).must_equal true
    end
  end
end
