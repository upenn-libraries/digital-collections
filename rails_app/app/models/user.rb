# frozen_string_literal: true

# Blacklight user
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  DISPLAY_KEY = :email

  # Originally included by Blacklight::User, which we removed (no bookmarks, search history)
  def string_display_key
    send(DISPLAY_KEY)
  end

  def to_s
    string_display_key
  end
end
