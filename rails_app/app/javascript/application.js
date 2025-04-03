// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@samvera/clover-iiif"
import { defineCustomElements } from "@penn-libraries/web"

defineCustomElements();

