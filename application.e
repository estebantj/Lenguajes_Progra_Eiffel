note
	description: "Tarea programada numero 3. Esteban Torres. 2018088849"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	archivos_cargados: HASH_TABLE[JSON_CONTAINER,STRING]
	file_manager: FILEREADER

	imprimir_archivo(nombre:STRING)
		local
			contenedor: JSON_CONTAINER
		do
			if archivos_cargados.has (nombre) then
				contenedor := archivos_cargados.at (nombre)
				if contenedor /= void then
					contenedor.print_jsons
				end
			else
				print("Nombre no encontrado%N")
			end
		end

	save_file_option(linea_leida_separada: LIST[STRING])
		local
			contenedor: JSON_CONTAINER
		do
			if archivos_cargados.has (linea_leida_separada[2]) then
				contenedor := archivos_cargados.at (linea_leida_separada[2])
				if contenedor /= void then
					file_manager.save_json_to_file (linea_leida_separada[3], contenedor)
				end
			else
				print("Nombre no encontrado%N")
			end
		end

	make
		local
			i: INTEGER
			linea_leida: STRING
			linea_leida_separada: LIST[STRING]
			comando: STRING
			contenedor: JSON_CONTAINER

		do
			create archivos_cargados.make(10)
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
						contenedor := file_manager.load_csv_as_json(linea_leida_separada[3])
						archivos_cargados.put (contenedor, linea_leida_separada[2])
					end
					if comando.is_equal ("save") then
						save_file_option(linea_leida_separada)
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
					if comando.is_equal ("imprimir") then
						imprimir_archivo(linea_leida_separada[2])
					end
					if comando.is_equal ("exit") then
						i := 2
					end
				end
				i := i-1
			end
		end
end
