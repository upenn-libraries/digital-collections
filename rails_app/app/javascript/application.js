import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap";
import Blacklight from "blacklight-frontend";
import "@penn-libraries/web/dist/web/web.esm.js"

import BlacklightRangeLimit from "blacklight-range-limit";
BlacklightRangeLimit.init({ onLoadHandler: Blacklight.onLoad });
