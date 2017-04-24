# frozen_string_literal: true
class ImpactsIndex
  DEFAULT_SORTING = { updated_at: :desc }
  SORTABLE_FIELDS = [:name, :updated_at, :created_at]
  PER_PAGE = 10

  delegate :params,      to: :controller
  delegate :impacts_url, to: :controller

  attr_reader :controller

  def initialize(controller)
    @controller = controller
  end

  def impacts
    @impacts       ||= Impact.fetch_all(options_filter)
    @impacts_items ||= @impacts.order(sort_params)
                               .paginate(page: current_page, per_page: per_page)
  end

  def total_items
    @total_items ||= @impacts.size
  end

  def links
    {
      first: impacts_url(rebuild_params.merge(first_page)),
      prev:  impacts_url(rebuild_params.merge(prev_page)),
      next:  impacts_url(rebuild_params.merge(next_page)),
      last:  impacts_url(rebuild_params.merge(last_page))
    }
  end

  private

    def options_filter
      params.permit('id', 'name', 'sort', 'impact', 'impact' => {}).tap do |filter_params|
        filter_params[:page]= {}
        filter_params[:page][:number] = params[:page][:number] if params[:page].present? && params[:page][:number].present?
        filter_params[:page][:size]   = params[:page][:size]   if params[:page].present? && params[:page][:size].present?
        filter_params
      end
    end

    def current_page
      (params.to_unsafe_h.dig('page', 'number') || 1).to_i
    end

    def per_page
      (params.to_unsafe_h.dig('page', 'size') || PER_PAGE).to_i
    end

    def first_page
      { page: { number: 1 } }
    end

    def next_page
      { page: { number: [total_pages, current_page + 1].min } }
    end

    def prev_page
      { page: { number: [1, current_page - 1].max } }
    end

    def last_page
      { page: { number: total_pages } }
    end

    def total_pages
      @total_pages ||= impacts.total_pages
    end

    def sort_params
      SortParams.sorted_fields(params[:sort], SORTABLE_FIELDS, DEFAULT_SORTING)
    end

    def rebuild_params
      @rebuild_params = begin
        rejected = ['action', 'controller']
        params.to_unsafe_h.reject { |key, value| rejected.include?(key.to_s) }
      end
    end
end
