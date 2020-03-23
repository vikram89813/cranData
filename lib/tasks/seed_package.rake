namespace :seed_package do

		task :download => :environment do
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
					puts rs[1]
					package_n.push(rs[1])
				end
			end

			rr.each do |line|
				rs = line.split(" ")
				if rs[0] == "Version:"
					puts rs[1]
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
          'Description:' => :discription,
      }

			final_list.each do |uri|
				tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(uri))
				tar_extract.rewind # The extract has to be rewinded after every iteration
				desc = nil
				tar_extract.each do |entry|
					if entry.full_name.ends_with?('DESCRIPTION')
						desc = entry.read
					end
        end
        desc_arr = desc.split("\n")

        desc_arr.each do |line|
          package_obj = {}
          ['Package:', 'Date/Publication:', 'Title:', 'Version:', 'Description:'].each do |type|
						if line.starts_with(type)
              val = line.split(type)[1].strip
							package_obj[variable_map[type]] = val
						end
          end

					['Author:', 'Maintainer:'].each do |type|
						if line.starts_with(type)
							val = line.split(type)[1].strip

							a = val.split(',')
							b = a.last.split('and') if a.last.include?('and')
							if b.present?
								a.pop
							end
							names = [a]
							names << b if b.present?
							names.flatten.map(&:strip)

							if type == 'Author:'
                names.each do |name_str|
                  email = nil
                  if (name_str.include?('<'))
                    name = name_str.split('<')[0]
                    email = name_str.split('<')[1].gsub('>','')
                  end
                  author = Author.where(name: name, email: email).first_or_create!

                end
              else
								names.each do |name_str|
									email = nil
									if (name_str.include?('<'))
										name = name_str.split('<')[0]
										email = name_str.split('<')[1].gsub('>','')
									end
                  maintainer = Maintainer.where(name: name, email: email).first_or_create!

								end

							end

            end
					end
        end

				tar_extract.close
			end

  	end

end
