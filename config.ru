# frozen_string_literal: true

require_relative './app'

use Rack::Static,
  urls: ['/dist'],
  root: 'client',
  header_rules: [
    [:all, { 'Cache-Control' => 'public, max-age=31536000' }],
  ]

run Sample::App
