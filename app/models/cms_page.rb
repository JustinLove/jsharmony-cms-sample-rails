class CmsPage
  def initialize(json)
    @data = json || {}
    @seo = Seo.new(@data['seo'])
    @content = Content.new(@data['content'])
    @properties = Properties.new(@data['properties'])
  end

  attr_reader :seo
  attr_reader :content
  attr_reader :properties

  def css
    data['css'] || ''
  end

  def js
    data['js'] || ''
  end

  def header
    data['header'] || ''
  end

  def footer
    data['footer'] || ''
  end

  def title
    data['title'] || ''
  end

  private

  attr_reader :data

  class Seo
    def initialize(json)
      @data = json || {}
    end

    def title
      data['title'] || ''
    end

    def keywords
      data['keywords'] || ''
    end

    def metadesc
      data['metadesc'] || ''
    end

    def canonical_url
      data['canonical_url'] || ''
    end

    private

    attr_reader :data
  end

  class Content
    def initialize(json)
      @data = json || {}
    end

    def respond_to_missing?(key)
      data && data.member?(key.to_s) || super
    end

    def method_missing(key)
      data && data[key.to_s]&.to_s || ''
    end

    private

    attr_reader :data
  end

  class Properties < Content; end
end