# frozen_string_literal: true

require_relative 'lib/spectrum'

map '/healthz' do
  run ->(_) { [200, {}, []] }
end

map '/favicon.ico' do
  run ->(_) { [404, {}, []] }
end

run Spectrum::Router
