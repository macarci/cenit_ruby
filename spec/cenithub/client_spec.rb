require "spec_helper"

describe Cenithub::Client do

  context "push json" do

    before do
      Cenithub.configure do |config|
        config.connection_id = "123"
        config.connection_token = "token"
      end
      stub_request(:post, "https://www.cenithub.com/api/v1/push").
        with(
          :body => "name:value",
          :headers => {
            'Content-Type'=>'application/json',
            'X-Hub-Access-Token'=>'token',
            'X-Hub-Store'=>'123',
            'X-Hub-Timestamp'=>/.*/}
        ).to_return(:status => 202, :body => "", :headers => {})
    end

    it "sends the connection_id and token as headers" do
      Cenithub::Client.push("name:value")
    end

    context "with response not 202" do
      before do
        stub_request(:post, "https://www.cenithub.com/api/v1/push").
          with(
            :body => "name:value",
            :headers => {
              'Content-Type'=>'application/json',
              'X-Hub-Access-Token'=>'token',
              'X-Hub-Store'=>'123',
              'X-Hub-Timestamp'=>/.*/}
          ).to_return(:status => 404, :body => "Cenithub error", :headers => {})
      end

      it "will raise PushApiException" do
        expect{ Cenithub::Client.push("name:value")}.to raise_error(Cenithub::Client::PushApiError, "Push not successful. Cenit returned response code 404 and message: wombat error")
      end
    end
  end

end
