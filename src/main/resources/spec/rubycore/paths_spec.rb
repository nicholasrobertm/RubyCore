# frozen_string_literal: true

require_relative '../../rubycore/forge/paths'

describe RubyCore::Paths do
  before(:each) do
    @paths = RubyCore::Paths.new
    @testdir = 'test'
  end

  it '.create' do
    @paths.create(@testdir)
    expect @paths.exist?(@testdir)
  end

  after(:each) do
    Dir.delete(@testdir)
  end
end
