// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import * as bootstrap from "bootstrap";
import githubAutoCompleteElement from "@github/auto-complete-element";
import Blacklight from "blacklight-frontend";

import BlacklightRangeLimit from "blacklight-range-limit";
BlacklightRangeLimit.init({ onLoadHandler: Blacklight.onLoad });
