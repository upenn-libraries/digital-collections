import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap";
import Blacklight from "blacklight-frontend";

import BlacklightRangeLimit from "blacklight-range-limit";
BlacklightRangeLimit.init({ onLoadHandler: Blacklight.onLoad });
