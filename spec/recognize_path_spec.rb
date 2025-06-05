# encoding: UTF-8

require 'spec_helper'

describe "recognize-path" do
  it 'fails gracefully if no path is given' do
    output = mock_pry('recognize-path', 'exit-all')
    _(output).must_match \
      "Error: The command 'recognize-path' requires an argument.\n"
  end

  it "prints info about controller/action that is bound to the given path" do
    output = mock_pry('recognize-path example.com', 'exit-all')
    _(output).must_match(/controller.+cars/)
    _(output).must_match(/action.+index/)
  end

  it "accepts short path" do
    output = mock_pry('recognize-path /cars/1/edit', 'exit-all')
    _(output).must_match(/action.+edit/)
    _(output).must_match(/controller.+cars/)
    _(output).must_match(/id.+1/)
  end

  it "accepts -m switch" do
    output = mock_pry('recognize-path example.com/cars -m post', 'exit-all')
    _(output).must_match(/controller.+cars/)
    _(output).must_match(/action.+create/)
  end

  it "doesn't accept unknown methods" do
    output = mock_pry('recognize-path example.com/cars -m posty', 'exit-all')
    _(output).must_match 'Unknown HTTP method: posty'
  end

  it "doesn't accept unknown routes" do
    output = mock_pry('recognize-path bing/bang/bong', 'exit-all')
    _(output).must_match 'No route matches "http://bing/bang/bong"'
  end
end
