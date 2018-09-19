# README

Hi, This is an application mainly an API one for making short URLs and can fetch the stats of the shortened URL which consists of some
information. Also the application is also intelligent enough the redirect the shortened URL to the main URL.

Model Description
It contains two models:
1) Shortened URL
2) Visitor

Shortened URL has an association with visitor as HAS MANY.

Controller/Request Flow Description.
It has mainly 3 endpoint.
1) POST create '/create'
This endpoint excepts a parameter {url:''} and can return {shortened_url: ''} with 201 as response if url is valid else render a 422.
2) GET show 'shortened_url' i.e. '<SCHEME>://ma.io/<UNIQUI_KEY>' or '/<UNIQUI_KEY>'
This endpoint is responsible in redirection to mail url if shortened_url(Unique_key) exists in the system. If shortened_url exists in the
system, it will redirect to main url with 302 simultaneously storing info of visitor and use_count else redirect to index.
3) GET stats '/stats'
This endpoint accepts a parameter {url:''} i.e. shortened_url and can return information shortened_url like its use_count,
visitor info(visited_at, visitor_ip, visitor_agent(browser))
4) GET index 'root'
This end will show app info.

Test Case Description.
It has a spec file under spec/request/shortened_url_service_request_spec.rb which is response fo testing the request flow of the system
using rspec.

Deployment Description.
Application is deployed on Heroku with the url: https://tranquil-mountain-49830.herokuapp.com/

Improvement Scope:
I can add user authentication in request flow.
