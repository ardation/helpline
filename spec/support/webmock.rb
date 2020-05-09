# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    stub_request(:post, ENV['ZEIT_WEBHOOK_URL'])
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: '', headers: {})
    stub_request(
      :get,
      'https://www.recaptcha.net/recaptcha/api/siteverify'\
      "?remoteip=127.0.0.1&response=abc&secret=#{ENV['RECAPTCHA_SECRET_KEY']}"
    ).to_return(body: { success: true, score: 0.5 }.to_json)
  end
end
