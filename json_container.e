note
	description: "Summary description for {JSON_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_CONTAINER

create
	make

feature {NONE}
	lista_jsons: LINKED_LIST[JSON_OBJECT]

feature
	make
		do
			create lista_jsons.make
		end

	save_json (json: JSON_OBJECT)
		do
			lista_jsons.put_left (json)
		end
end
