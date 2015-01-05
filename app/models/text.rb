class Text < ActiveRecord::Base

	#attr_accessible :body, :edition_id, :comments, :title, :abstract, :notes, :bibliography, :source_file, :authors, :author_ids, :part, :part_id, :sorting, :is_static

	has_and_belongs_to_many :authors
	belongs_to :part
	belongs_to :edition
	has_many :keywords
  has_many :comments
  has_many :sentences
	has_many :annotations

	def author_names
		self.authors.collect { |author| author.name }.join(', ')
	end

  def comment_counts
    comments.count(group: :sentence_checksum)
  end

	def as_json(options={})
		if options[:bootstrap] == true
			{
				:id => id,
				:title => title,
				:part => part_id,
				:is_static => is_static,
				:authors => authors

			}
		else
			{
        :comments => comment_counts,
				:id => id,
				:title => title,
				:part => part_id,
				:is_static => is_static,
				:body => body,
				:notes => notes,
				:bibliography => bibliography,
				:authors => authors,
				:edition => edition.label,
				:keywords_grouped => keywords.all_grouped,
				:sentences => annotations.all_grouped
			}
		end
	end

end
