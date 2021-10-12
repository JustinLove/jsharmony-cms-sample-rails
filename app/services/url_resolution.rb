module UrlResolution
  class Strict
    def call(path, trailing_slash)
      [path]
    end
  end

  class DefaultDocument
    attr_reader :default_document

    def initialize(doc)
      @default_document = doc
    end

    def call(path, trailing_slash)
      if trailing_slash
        [File.join(path, default_document)]
      else
        url_ext = File.extname(path)
        default_ext = File.extname(default_document)
        if url_ext.empty? || default_ext.empty? || (url_ext != default_ext)
          [path, File.join(path, default_document)]
        else
          [path]
        end
      end
    end
  end

  def self.strict; Strict.new; end
  def self.default_document(doc); DefaultDocument.new(doc); end
end