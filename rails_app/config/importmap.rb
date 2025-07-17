# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin '@popperjs/core', to: 'https://ga.jspm.io/npm:@popperjs/core@2.11.6/dist/umd/popper.min.js'
pin 'bootstrap', to: 'https://ga.jspm.io/npm:bootstrap@5.3.5/dist/js/bootstrap.js'

# chart.js is dependency of blacklight-range-limit, currently is not working
# as vendored importmaps, but instead must be pinned to CDN. You may want to update
# versions periodically.
pin 'chart.js', to: 'https://ga.jspm.io/npm:chart.js@4.2.0/dist/chart.js'
# single dependency of chart.js:
pin '@kurkle/color', to: 'https://ga.jspm.io/npm:@kurkle/color@0.3.2/dist/color.esm.js'

# clover-iiif
pin 'react', to: 'https://esm.sh/react@19.1.0'
pin 'react-dom/client', to: 'https://esm.sh/react-dom@19.1.0/client'
pin '@samvera/clover-iiif/viewer', to: 'https://esm.sh/@samvera/clover-iiif@2.18.3/dist/viewer'
pin '@samvera/clover-iiif/image', to: 'https://esm.sh/@samvera/clover-iiif@2.18.3/dist/image'
