# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin @samvera/clover-iiif', to: 'https://www.unpkg.com/@samvera/clover-iiif@latest/dist/web-components/index.umd.js'
pin '@penn-libraries/web', to: 'https://cdn.jsdelivr.net/npm/@penn-libraries/web@latest/loader/index.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'