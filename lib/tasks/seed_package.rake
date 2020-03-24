require 'open-uri'
require 'fileutils'
require 'rubygems/package'

namespace :seed_package do

		task :download => :environment do
      Author.destroy_all
			Author.destroy_all
      Maintainer.destroy_all
      Package.destroy_all
			MaintainerPackage.destroy_all
			response = HTTParty.get('https://cran.r-project.org/src/contrib/PACKAGES', {
			headers: {
				"Content-Type"=> "application/json",
				"Range" => "Bytes=0-21350"}
			})

			rb = response.body
			rr = rb.split("\n")

			package_n = []
			package_v = []

			rr.each do |line|
				rs = line.split(" ")
				if rs[0] == "Package:"
					package_n.push(rs[1])
				end
			end

			rr.each do |line|
				rs = line.split(" ")
				if rs[0] == "Version:"
					package_v.push(rs[1])
				end
      end

      final_list = []
			url = "https://cran.r-project.org/src/contrib/NAME.tar.gz"

			for i in (0...package_n.size)
        p_name = package_n[i]
        v_name = package_v[i]
        final_str = p_name + "_" + v_name
        t_url = url.gsub("NAME", final_str)
        final_list.push(t_url)
      end

      puts "========="
      puts "URLs Constructed"
      puts "========="

      variable_map = {
          'Package:' => :name,
          'Date/Publication:' => :date,
          'Title:' => :title,
          'Version:' => :version,
          'Description:' => :discription
      }

      count = 0
			threads = []
			final_list.in_groups_of(10) do |group_uri|
				group_uri.each do |uri|
					threads << Thread.new {
						count = count + 1
						puts count
						source = open(uri)
						begin
							tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(source))
						rescue
							next
						end
						tar_extract.rewind # The extract has to be rewinded after every iteration
						desc = nil
						tar_extract.each do |entry|
							if entry.full_name.ends_with?('DESCRIPTION')
								desc = entry.read
							end
						end
						desc_arr = desc.split("\n")
						package_obj = {}
						author_ids = []
						maintainer_ids = []
						desc_arr.each do |line|
							type = "#{line.split(':')[0]}:"
							package_details = ['Package:', 'Date/Publication:', 'Title:', 'Version:', 'Description:']
							if line.starts_with?(*package_details)
								val = line.split(type)[1].strip
								package_obj[variable_map[type]] = val
							else
								author_maintainer = ['Author:', 'Maintainer:']
								if line.starts_with?(*author_maintainer)
									val = line.split(type)[1].strip

									a = val.split(',')
									b = a.last.split('and') if a.last.include?(' and ')
									if b.present?
										a.pop
									end
									names = [a]
									names << b if b.present?
									names.flatten!.map(&:strip)

									author_maintainer_data = []

									names.each do |name_str|
										email = nil
										name = name_str
										if (name_str.include?('<'))
											name = name_str.split('<')[0]
											email = name_str.split('<')[1].gsub('>','')
										end
										author_maintainer_data << {name: name, email: email}
									end

									author_maintainer_data.each do |values|
										if type == 'Author:'
											author = Author.where(values).first_or_create!
											author_ids << author.id
										else
											maintainer = Maintainer.where(values).first_or_create!
											maintainer_ids << maintainer.id
										end
									end
								end
							end
						end

						package = Package.create!(package_obj)

						author_ids.each do |author_id|
							AuthorPackage.create!(package_id: package.id, author_id: author_id)
						end

						maintainer_ids.each do |maintainer_id|
							MaintainerPackage.create!(package_id: package.id, maintainer_id: maintainer_id)
						end

						tar_extract.close
					}
				end
				threads.each(&:join)
      end
  	end

end
