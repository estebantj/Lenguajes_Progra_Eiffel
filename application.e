note
	description: "Tarea programada numero 3. Esteban Torres. 2018088849"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization
	make
		local
			i: INTEGER
			linea_leida: STRING
			linea_leida_separada: LIST[STRING]
			comando: STRING
			table: HASH_TABLE[ANY,STRING]
			file_manager: FILEREADER
		do
			create table.make(10)
			create file_manager
			from
				i := 0
			until
				i >= 1
			loop
				Io.read_line
				linea_leida := Io.last_string
				if not linea_leida.is_empty then
					linea_leida_separada := linea_leida.split (' ')
					comando := linea_leida_separada[1]
					if comando.is_equal ("load") then
						file_manager.load_csv_as_json(linea_leida_separada[3])
					end
					if comando.is_equal ("save") then
						print("save comando")
					end
					if comando.is_equal ("savecsv") then
						print("savecsv comando")
					end
					if comando.is_equal ("select") then
						print("select comando")
					end
					if comando.is_equal ("project") then
						print("project comando")
					end
					if comando.is_equal ("exit") then
						i := 2
					end
				end
				i := i-1
			end
		end
end
