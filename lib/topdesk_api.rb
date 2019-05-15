module TopdeskAPI; end

require 'topdesk_api/client'
require 'topdesk_api/resources/tickets'
require 'topdesk_api/middleware/response/raise_error'
require 'topdesk_api/middleware/response/parse_json'
require 'topdesk_api/middleware/response/sanitize'
