# frozen_string_literal: true

# Blacklight controller that handles searches and document requests
class CatalogController < ApplicationController
  include Blacklight::Catalog
  include BlacklightRangeLimit::ControllerOverride

  # If you'd like to handle errors returned by Solr in a certain way,
  # you can use Rails rescue_from with a method you define in this controller,
  # uncomment:
  #
  # rescue_from Blacklight::Exceptions::InvalidRequest, with: :my_handling_method

  configure_blacklight do |config|
    ## Specify the style of markup to be generated (may be 4 or 5)
    # config.bootstrap_version = 5
    #
    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response
    #
    ## The destination for the link around the logo in the header
    # config.logo_link = root_path
    #
    ## Should the raw solr document endpoint (e.g. /catalog/:id/raw) be enabled
    # config.raw_endpoint.enabled = false

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      rows: 10
    }

    # solr path which will be added to solr base url before the other solr params.
    # config.solr_path = 'select'
    # config.document_solr_path = 'get'
    # config.json_solr_path = 'advanced'

    # items to show per page, each number in the array represent another option to choose from.
    # config.per_page = [10,20,50,100]

    # solr field configuration for search results/index views
    config.index.title_field = 'title_ssim'
    # config.index.display_type_field = 'format'
    config.index.thumbnail_method = :thumbnail

    # The presenter is the view-model class for the page
    # config.index.document_presenter_class = MyApp::IndexPresenter

    # Some components can be configured
    # config.index.document_component = MyApp::SearchResultComponent
    # config.index.constraints_component = MyApp::ConstraintsComponent
    # config.index.search_bar_component = MyApp::SearchBarComponent
    # config.index.search_header_component = MyApp::SearchHeaderComponent
    # config.index.document_actions.delete(:bookmark)

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    # solr field configuration for document/show views
    config.show.title_field = 'title_ssim'
    # config.show.display_type_field = 'format'
    # config.show.thumbnail_field = 'thumbnail_path_ss'
    #
    # The presenter is a view-model class for the page
    # config.show.document_presenter_class = MyApp::ShowPresenter
    #
    # These components can be configured
    # config.show.document_component = MyApp::DocumentComponent
    # config.show.sidebar_component = MyApp::SidebarComponent
    # config.show.embed_component = MyApp::EmbedComponent

    # Blacklight-gallery configuration
    config.view.gallery(document_component: GalleryComponent, icon: Blacklight::Gallery::Icons::GalleryComponent)

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically
    #  across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation
    # (note: It is case sensitive when searching values)

    config.add_facet_fields_to_solr_request!

    config.add_facet_field :physical_format_ssim, label: I18n.t('fields.facets.form')
    config.add_facet_field :language_ssim, label: I18n.t('fields.facets.language')
    config.add_facet_field :subject_ssim, label: I18n.t('fields.facets.subject')
    config.add_facet_field :collection_ssim, label: I18n.t('fields.facets.collection')
    config.add_facet_field :creator_with_role_ssim, label: I18n.t('fields.facets.creator')
    config.add_facet_field :year_itim, label: I18n.t('fields.facets.year'), range: true

    # "Index"/results page fields
    config.add_index_field :description_ssim, label: I18n.t('fields.results.description')
    config.add_index_field :physical_format_ssim, label: I18n.t('fields.results.form'), link_to_facet: true,
                                                  gallery: true
    config.add_index_field :creator_with_role_ssim, label: I18n.t('fields.results.creator'), link_to_facet: true
    config.add_index_field :subject_ssim, label: I18n.t('fields.results.subject'), link_to_facet: true
    config.add_index_field :collection_ssim, label: I18n.t('fields.results.collection'), link_to_facet: true

    # "Show"/work page fields
    config.add_show_field :description_ssim, label: I18n.t('fields.work.description')
    config.add_show_field :creator_with_role_ssim, label: I18n.t('fields.work.creator'), link_to_facet: true
    # Place of publication
    # Genre
    config.add_show_field :date_ssim, label: I18n.t('fields.work.date')
    config.add_show_field :language_ssim, label: I18n.t('fields.work.language'), link_to_facet: true
    config.add_show_field :subject_ssim, label: I18n.t('fields.work.subject'), link_to_facet: true
    # Related URL
    config.add_show_field :collection_ssim, label: I18n.t('fields.work.collection'), link_to_facet: true
    config.add_show_field :physical_location_ssim, label: I18n.t('fields.work.location')
    # URI
    config.add_show_field :rights_ssim, label: I18n.t('fields.work.rights')
    config.add_show_field :unique_identifier_ssi, label: I18n.t('fields.work.identifier')

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', label: 'All Fields'

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('title') do |field|
      field.solr_parameters = {
        qf: 'title_tesim',
        pf: 'title_tesim'
      }
    end

    config.add_search_field('creator') do |field|
      field.solr_parameters = {
        qf: 'creator_tesim',
        pf: 'creator_tesim'
      }
    end

    config.add_search_field('subject') do |field|
      field.solr_parameters = {
        qf: 'subject_tesim',
        pf: 'subject_tesim'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the Solr field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case). Add the sort: option to configure a
    # custom Blacklight url parameter value separate from the Solr sort fields.
    config.add_sort_field 'relevance', sort: 'score desc, pub_date_si desc, title_si asc', label: 'relevance'
    config.add_sort_field 'year-desc', sort: 'pub_date_si desc, title_si asc', label: 'year'
    config.add_sort_field 'author', sort: 'author_si asc, title_si asc', label: 'author'
    config.add_sort_field 'title_si asc, pub_date_si desc', label: 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggester
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'
    # if the name of the solr.SuggestComponent provided in your solrconfig.xml is not the
    # default 'mySuggester', uncomment and provide it below
    # config.autocomplete_suggester = 'mySuggester'
  end
end
