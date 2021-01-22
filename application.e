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
	file_manager: FILE_READER_WRITER

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

	savecsv_file_option(linea_leida_separada: LIST[STRING])
		local
			contenedor: JSON_CONTAINER
		do
			if archivos_cargados.has (linea_leida_separada[2]) then
				contenedor := archivos_cargados.at (linea_leida_separada[2])
				if contenedor /= void then
					file_manager.save_json_csv (linea_leida_separada[3], contenedor)
					--print(contenedor.create_csv_string)
					--Io.new_line
				end
			else
				print("Nombre no encontrado%N")
			end
		end

	select_option(linea_leida_separada: LINKED_LIST[STRING])
		local
			contenedor: JSON_CONTAINER
			nuevo_contenedor: JSON_CONTAINER
			nueva_lista: LINKED_LIST[STRING]
		do
			create nueva_lista.make_from_iterable (linea_leida_separada)
			nueva_lista.remove_i_th (1)
			nueva_lista.remove_i_th (1)
			nueva_lista.remove_i_th (1)
			if archivos_cargados.has (linea_leida_separada[2]) then
				contenedor := archivos_cargados.at (linea_leida_separada[2])
				if contenedor /= void then
					nuevo_contenedor := contenedor.select_option (nueva_lista)
					archivos_cargados.put (nuevo_contenedor, linea_leida_separada[3])
				end
			else
				print("Nombre no encontrado%N")
			end
		end

	project_option(linea_leida_separada: LINKED_LIST[STRING])
		local
			contenedor: JSON_CONTAINER
			nuevo_contenedor: JSON_CONTAINER
			nueva_lista: LINKED_LIST[STRING]
		do
			create nueva_lista.make_from_iterable (linea_leida_separada)
			nueva_lista.remove_i_th (1)
			nueva_lista.remove_i_th (1)
			nueva_lista.remove_i_th (1)
			if archivos_cargados.has (linea_leida_separada[2]) then
				contenedor := archivos_cargados.at (linea_leida_separada[2])
				if contenedor /= void then
					nuevo_contenedor := contenedor.project (nueva_lista)
					archivos_cargados.put (nuevo_contenedor, linea_leida_separada[3])
				end
			else
				print("Nombre no encontrado%N")
			end
		end

	make
		local
			i: INTEGER
			linea_leida: STRING
			linea_leida_separada: LINKED_LIST[STRING]
			comando: STRING
			contenedor: JSON_CONTAINER

		do
			create archivos_cargados.make(10)
			create file_manager
			create linea_leida_separada.make
			from
				i := 0
			until
				i >= 1
			loop
				Io.read_line
				linea_leida := Io.last_string
				if not linea_leida.is_empty then
					linea_leida.right_adjust
					linea_leida.left_adjust
					linea_leida_separada.wipe_out
					linea_leida_separada.append (linea_leida.split (' '))
					comando := linea_leida_separada[1]
					if comando.is_equal ("load") then
						contenedor := file_manager.load_csv_as_json(linea_leida_separada[3])
						archivos_cargados.put (contenedor, linea_leida_separada[2])
					elseif comando.is_equal ("save") then
						save_file_option(linea_leida_separada)
					elseif comando.is_equal ("savecsv") then
						savecsv_file_option(linea_leida_separada)
					elseif comando.is_equal ("select") then
						select_option(linea_leida_separada)
					elseif comando.is_equal ("project") then
						project_option(linea_leida_separada)
					elseif comando.is_equal ("imprimir") then
						imprimir_archivo(linea_leida_separada[2])
					elseif comando.is_equal ("exit") then
						i := 2
					end
				end
				i := i-1
			end
		end
end
