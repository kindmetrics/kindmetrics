module LanguageList
  CACHE_DIR  = File.expand_path(Dir.current) + "/cache"
  class LanguageInfo
    property name : String, iso_639_3 : String?, iso_639_1 : String?, iso_639_2b : String?, iso_639_2t : String?, type : String?

    @common_name : String?

    def initialize(options)
      @name = options[":name"].as_s
      @common_name = options[":common_name"]?.try { |c| c.as_s? }
      @iso_639_3 = options[":iso_639_3"]?.try { |c| c.as_s? }
      @iso_639_1 = options[":iso_639_1"]?.try { |c| c.as_s? }
      @iso_639_2b = options[":iso_639_2b"]?.try { |c| c.as_s? }
      @iso_639_2t = options[":iso_639_2t"]?.try { |c| c.as_s? }
      @type = options[":type"]?.try { |c| c.as_s? }
    end

    def common_name
      @common_name || @name
    end

    def common?
      @common
    end

    def <=>(other)
      @name <=> other.name
    end

    def iso_639_1?
      !@iso_639_1.nil?
    end

    {% for x in %w(ancient constructed extinct historical living special) %}
      def {{x.id}}?
        @type == {{x.id}}
      end
    {% end %}

    def to_s
      "#{@iso_639_3}#{" (#{@iso_639_1})" if @iso_639_1} - #{@name}"
    end

    def self.find_by_iso_639_1(code)
      LanguageList::BY_ISO_639_1[code]
    end

    def self.find_by_iso_639_3(code)
      LanguageList::BY_ISO_639_3[code]
    end

    def self.find_by_iso_639_2b(code)
      LanguageList::BY_ISO_639_2B[code]
    end

    def self.find_by_iso_639_2t(code)
      LanguageList::BY_ISO_639_2T[code]
    end

    def self.find_by_name(name)
      return if name.nil?

      LanguageList::BY_NAME[name.downcase]
    end

    def self.find(code)
      return if code.nil?

      code = code.downcase
      find_by_iso_639_1(code) ||
        find_by_iso_639_3(code) ||
        find_by_iso_639_2b(code) ||
        find_by_iso_639_2t(code) ||
        find_by_name(code)
    end
  end

  ALL_LANGUAGES = begin
    yaml_data = YAML.parse(File.read(LanguageList::CACHE_DIR + "/languages.yml"))
    yaml_data.as_a.map{|e| LanguageInfo.new(e) }
  end
  ISO_639_1 = ALL_LANGUAGES.select(&:iso_639_1?)
  LIVING_LANGUAGES = ALL_LANGUAGES.select(&:living?)
  COMMON_LANGUAGES = ALL_LANGUAGES.select(&:common?)

  BY_NAME      = {} of String => LanguageInfo
  BY_ISO_639_1 = {} of String => LanguageInfo
  BY_ISO_639_3 = {} of String => LanguageInfo
  BY_ISO_639_2B = {} of String => LanguageInfo
  BY_ISO_639_2T = {} of String => LanguageInfo
  ALL_LANGUAGES.each do |lang|
    BY_NAME[lang.name.downcase] = lang
    BY_NAME[lang.common_name.not_nil!.downcase] = lang if lang.common_name
    BY_ISO_639_1[lang.iso_639_1.not_nil!] = lang if lang.iso_639_1
    BY_ISO_639_3[lang.iso_639_3.not_nil!] = lang if lang.iso_639_3
    BY_ISO_639_2B[lang.iso_639_2b.not_nil!] = lang if lang.iso_639_2b
    BY_ISO_639_2T[lang.iso_639_2t.not_nil!] = lang if lang.iso_639_2t
  end
end
