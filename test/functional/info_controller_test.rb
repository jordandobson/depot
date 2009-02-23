require 'test_helper'

class InfoControllerTest < ActionController::TestCase

  test "html who_bought controller request returns html" do
    get :who_bought, :id => products(:one).id
    assert_response :success
    # Ensure it has HTML TAGS in the response body
    assert_match /<html>.*<\/html>/m, @response.body
  end

  test "xml who_bought controller request returns html" do
    get :who_bought, :id => products(:one).id, :format => "xml"
    assert_response :success
    # Ensure it has XML TAG in the response body
    assert_match /<?xml.*>\n/, @response.body
    # Ensure it has product node with title node inside
    assert_match /<product>.*<title>.+<\/title>.*<\/product>/m, @response.body
  end

  test "json who_bought controller request returns json" do
    get :who_bought, :id => products(:one).id, :format => "json"
    assert_response :success
    # Ensure it has prouct and orders in the response body
    assert_match /\A\{"product": \{.*"orders": \[.*\}\}/, @response.body
  end

  test "atom who_bought controller request returns atom" do
    get :who_bought, :id => products(:one).id, :format => "atom"
    assert_response :success
    # Ensure it has XML TAG in the response body
    # puts  @response.body
    assert_match /<?xml.*?>\n<feed.*xmlns="http:\/\/www.w3.org\/2005\/Atom">/, @response.body
  end

end
