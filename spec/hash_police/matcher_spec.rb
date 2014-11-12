require 'hash_police'
require 'hash_police/rspec_matcher'

describe 'Matcher' do
  it "should be able to use the matcher `have_the_same_hash_format_as`" do
    expected = { 'str' => '', 'an_arr' => [ 1 ] }
    to_be_checked = { 'str' => 'hola', :an_arr => [1,3,4] }

    expect(to_be_checked).to have_the_same_hash_format_as(expected)
  end
end
