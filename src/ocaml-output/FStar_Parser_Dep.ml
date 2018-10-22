open Prims
type verify_mode =
  | VerifyAll 
  | VerifyUserList 
  | VerifyFigureItOut 
let (uu___is_VerifyAll : verify_mode -> Prims.bool) =
  fun projectee  ->
    match projectee with | VerifyAll  -> true | uu____9 -> false
  
let (uu___is_VerifyUserList : verify_mode -> Prims.bool) =
  fun projectee  ->
    match projectee with | VerifyUserList  -> true | uu____20 -> false
  
let (uu___is_VerifyFigureItOut : verify_mode -> Prims.bool) =
  fun projectee  ->
    match projectee with | VerifyFigureItOut  -> true | uu____31 -> false
  
type files_for_module_name =
  (Prims.string FStar_Pervasives_Native.option,Prims.string
                                                 FStar_Pervasives_Native.option)
    FStar_Pervasives_Native.tuple2 FStar_Util.smap
type color =
  | White 
  | Gray 
  | Black 
let (uu___is_White : color -> Prims.bool) =
  fun projectee  -> match projectee with | White  -> true | uu____54 -> false 
let (uu___is_Gray : color -> Prims.bool) =
  fun projectee  -> match projectee with | Gray  -> true | uu____65 -> false 
let (uu___is_Black : color -> Prims.bool) =
  fun projectee  -> match projectee with | Black  -> true | uu____76 -> false 
type open_kind =
  | Open_module 
  | Open_namespace 
let (uu___is_Open_module : open_kind -> Prims.bool) =
  fun projectee  ->
    match projectee with | Open_module  -> true | uu____87 -> false
  
let (uu___is_Open_namespace : open_kind -> Prims.bool) =
  fun projectee  ->
    match projectee with | Open_namespace  -> true | uu____98 -> false
  
let (check_and_strip_suffix :
  Prims.string -> Prims.string FStar_Pervasives_Native.option) =
  fun f  ->
    let suffixes = [".fsti"; ".fst"; ".fsi"; ".fs"]  in
    let matches =
      FStar_List.map
        (fun ext  ->
           let lext = FStar_String.length ext  in
           let l = FStar_String.length f  in
           let uu____146 =
             (l > lext) &&
               (let uu____159 = FStar_String.substring f (l - lext) lext  in
                uu____159 = ext)
              in
           if uu____146
           then
             let uu____180 =
               FStar_String.substring f (Prims.parse_int "0") (l - lext)  in
             FStar_Pervasives_Native.Some uu____180
           else FStar_Pervasives_Native.None) suffixes
       in
    let uu____197 = FStar_List.filter FStar_Util.is_some matches  in
    match uu____197 with
    | (FStar_Pervasives_Native.Some m)::uu____211 ->
        FStar_Pervasives_Native.Some m
    | uu____223 -> FStar_Pervasives_Native.None
  
let (is_interface : Prims.string -> Prims.bool) =
  fun f  ->
    let uu____240 =
      FStar_String.get f ((FStar_String.length f) - (Prims.parse_int "1"))
       in
    uu____240 = 105
  
let (is_implementation : Prims.string -> Prims.bool) =
  fun f  -> let uu____254 = is_interface f  in Prims.op_Negation uu____254 
let list_of_option :
  'Auu____261 .
    'Auu____261 FStar_Pervasives_Native.option -> 'Auu____261 Prims.list
  =
  fun uu___115_270  ->
    match uu___115_270 with
    | FStar_Pervasives_Native.Some x -> [x]
    | FStar_Pervasives_Native.None  -> []
  
let list_of_pair :
  'Auu____279 .
    ('Auu____279 FStar_Pervasives_Native.option,'Auu____279
                                                  FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 -> 'Auu____279 Prims.list
  =
  fun uu____294  ->
    match uu____294 with
    | (intf,impl) ->
        FStar_List.append (list_of_option intf) (list_of_option impl)
  
let (module_name_of_file : Prims.string -> Prims.string) =
  fun f  ->
    let uu____322 =
      let uu____326 = FStar_Util.basename f  in
      check_and_strip_suffix uu____326  in
    match uu____322 with
    | FStar_Pervasives_Native.Some longname -> longname
    | FStar_Pervasives_Native.None  ->
        let uu____333 =
          let uu____339 = FStar_Util.format1 "not a valid FStar file: %s" f
             in
          (FStar_Errors.Fatal_NotValidFStarFile, uu____339)  in
        FStar_Errors.raise_err uu____333
  
let (lowercase_module_name : Prims.string -> Prims.string) =
  fun f  ->
    let uu____353 = module_name_of_file f  in
    FStar_String.lowercase uu____353
  
let (namespace_of_module :
  Prims.string -> FStar_Ident.lident FStar_Pervasives_Native.option) =
  fun f  ->
    let lid =
      let uu____366 = FStar_Ident.path_of_text f  in
      FStar_Ident.lid_of_path uu____366 FStar_Range.dummyRange  in
    match lid.FStar_Ident.ns with
    | [] -> FStar_Pervasives_Native.None
    | uu____369 ->
        let uu____372 = FStar_Ident.lid_of_ids lid.FStar_Ident.ns  in
        FStar_Pervasives_Native.Some uu____372
  
type file_name = Prims.string
type module_name = Prims.string
type dependence =
  | UseInterface of module_name 
  | PreferInterface of module_name 
  | UseImplementation of module_name 
  | FriendImplementation of module_name 
let (uu___is_UseInterface : dependence -> Prims.bool) =
  fun projectee  ->
    match projectee with | UseInterface _0 -> true | uu____414 -> false
  
let (__proj__UseInterface__item___0 : dependence -> module_name) =
  fun projectee  -> match projectee with | UseInterface _0 -> _0 
let (uu___is_PreferInterface : dependence -> Prims.bool) =
  fun projectee  ->
    match projectee with | PreferInterface _0 -> true | uu____438 -> false
  
let (__proj__PreferInterface__item___0 : dependence -> module_name) =
  fun projectee  -> match projectee with | PreferInterface _0 -> _0 
let (uu___is_UseImplementation : dependence -> Prims.bool) =
  fun projectee  ->
    match projectee with | UseImplementation _0 -> true | uu____462 -> false
  
let (__proj__UseImplementation__item___0 : dependence -> module_name) =
  fun projectee  -> match projectee with | UseImplementation _0 -> _0 
let (uu___is_FriendImplementation : dependence -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | FriendImplementation _0 -> true
    | uu____486 -> false
  
let (__proj__FriendImplementation__item___0 : dependence -> module_name) =
  fun projectee  -> match projectee with | FriendImplementation _0 -> _0 
let (dep_to_string : dependence -> Prims.string) =
  fun uu___116_505  ->
    match uu___116_505 with
    | UseInterface f -> Prims.strcat "UseInterface " f
    | PreferInterface f -> Prims.strcat "PreferInterface " f
    | UseImplementation f -> Prims.strcat "UseImplementation " f
    | FriendImplementation f -> Prims.strcat "UseImplementation " f
  
type dependences = dependence Prims.list
let empty_dependences : 'Auu____524 . unit -> 'Auu____524 Prims.list =
  fun uu____527  -> [] 
type dependence_graph =
  | Deps of (dependences,color) FStar_Pervasives_Native.tuple2
  FStar_Util.smap 
let (uu___is_Deps : dependence_graph -> Prims.bool) = fun projectee  -> true 
let (__proj__Deps__item___0 :
  dependence_graph ->
    (dependences,color) FStar_Pervasives_Native.tuple2 FStar_Util.smap)
  = fun projectee  -> match projectee with | Deps _0 -> _0 
type deps =
  {
  dep_graph: dependence_graph ;
  file_system_map: files_for_module_name ;
  cmd_line_files: file_name Prims.list ;
  all_files: file_name Prims.list ;
  interfaces_with_inlining: file_name Prims.list }
let (__proj__Mkdeps__item__dep_graph : deps -> dependence_graph) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining;_} -> dep_graph
  
let (__proj__Mkdeps__item__file_system_map : deps -> files_for_module_name) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining;_} -> file_system_map
  
let (__proj__Mkdeps__item__cmd_line_files : deps -> file_name Prims.list) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining;_} -> cmd_line_files
  
let (__proj__Mkdeps__item__all_files : deps -> file_name Prims.list) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining;_} -> all_files
  
let (__proj__Mkdeps__item__interfaces_with_inlining :
  deps -> file_name Prims.list) =
  fun projectee  ->
    match projectee with
    | { dep_graph; file_system_map; cmd_line_files; all_files;
        interfaces_with_inlining;_} -> interfaces_with_inlining
  
let (deps_try_find :
  dependence_graph ->
    Prims.string ->
      (dependences,color) FStar_Pervasives_Native.tuple2
        FStar_Pervasives_Native.option)
  =
  fun uu____740  ->
    fun k  -> match uu____740 with | Deps m -> FStar_Util.smap_try_find m k
  
let (deps_add_dep :
  dependence_graph ->
    Prims.string ->
      (dependences,color) FStar_Pervasives_Native.tuple2 -> unit)
  =
  fun uu____778  ->
    fun k  ->
      fun v1  -> match uu____778 with | Deps m -> FStar_Util.smap_add m k v1
  
let (deps_keys : dependence_graph -> Prims.string Prims.list) =
  fun uu____805  -> match uu____805 with | Deps m -> FStar_Util.smap_keys m 
let (deps_empty : unit -> dependence_graph) =
  fun uu____825  ->
    let uu____826 = FStar_Util.smap_create (Prims.parse_int "41")  in
    Deps uu____826
  
let (mk_deps :
  dependence_graph ->
    files_for_module_name ->
      file_name Prims.list ->
        file_name Prims.list -> file_name Prims.list -> deps)
  =
  fun dg  ->
    fun fs  ->
      fun c  ->
        fun a  ->
          fun i  ->
            {
              dep_graph = dg;
              file_system_map = fs;
              cmd_line_files = c;
              all_files = a;
              interfaces_with_inlining = i
            }
  
let (empty_deps : deps) =
  let uu____883 = deps_empty ()  in
  let uu____884 = FStar_Util.smap_create (Prims.parse_int "0")  in
  mk_deps uu____883 uu____884 [] [] [] 
let (module_name_of_dep : dependence -> module_name) =
  fun uu___117_905  ->
    match uu___117_905 with
    | UseInterface m -> m
    | PreferInterface m -> m
    | UseImplementation m -> m
    | FriendImplementation m -> m
  
let (resolve_module_name :
  files_for_module_name ->
    module_name -> module_name FStar_Pervasives_Native.option)
  =
  fun file_system_map  ->
    fun key  ->
      let uu____934 = FStar_Util.smap_try_find file_system_map key  in
      match uu____934 with
      | FStar_Pervasives_Native.Some
          (FStar_Pervasives_Native.Some fn,uu____961) ->
          let uu____983 = lowercase_module_name fn  in
          FStar_Pervasives_Native.Some uu____983
      | FStar_Pervasives_Native.Some
          (uu____986,FStar_Pervasives_Native.Some fn) ->
          let uu____1009 = lowercase_module_name fn  in
          FStar_Pervasives_Native.Some uu____1009
      | uu____1012 -> FStar_Pervasives_Native.None
  
let (interface_of :
  files_for_module_name ->
    module_name -> file_name FStar_Pervasives_Native.option)
  =
  fun file_system_map  ->
    fun key  ->
      let uu____1045 = FStar_Util.smap_try_find file_system_map key  in
      match uu____1045 with
      | FStar_Pervasives_Native.Some
          (FStar_Pervasives_Native.Some iface,uu____1072) ->
          FStar_Pervasives_Native.Some iface
      | uu____1095 -> FStar_Pervasives_Native.None
  
let (implementation_of :
  files_for_module_name ->
    module_name -> file_name FStar_Pervasives_Native.option)
  =
  fun file_system_map  ->
    fun key  ->
      let uu____1128 = FStar_Util.smap_try_find file_system_map key  in
      match uu____1128 with
      | FStar_Pervasives_Native.Some
          (uu____1154,FStar_Pervasives_Native.Some impl) ->
          FStar_Pervasives_Native.Some impl
      | uu____1178 -> FStar_Pervasives_Native.None
  
let (has_interface : files_for_module_name -> module_name -> Prims.bool) =
  fun file_system_map  ->
    fun key  ->
      let uu____1207 = interface_of file_system_map key  in
      FStar_Option.isSome uu____1207
  
let (has_implementation : files_for_module_name -> module_name -> Prims.bool)
  =
  fun file_system_map  ->
    fun key  ->
      let uu____1227 = implementation_of file_system_map key  in
      FStar_Option.isSome uu____1227
  
let (cache_file_name : Prims.string -> Prims.string) =
  fun fn  ->
    let uu____1241 =
      let uu____1243 = FStar_Options.lax ()  in
      if uu____1243
      then Prims.strcat fn ".checked.lax"
      else Prims.strcat fn ".checked"  in
    FStar_Options.prepend_cache_dir uu____1241
  
let (file_of_dep_aux :
  Prims.bool ->
    files_for_module_name -> file_name Prims.list -> dependence -> file_name)
  =
  fun use_checked_file  ->
    fun file_system_map  ->
      fun all_cmd_line_files  ->
        fun d  ->
          let cmd_line_has_impl key =
            FStar_All.pipe_right all_cmd_line_files
              (FStar_Util.for_some
                 (fun fn  ->
                    (is_implementation fn) &&
                      (let uu____1300 = lowercase_module_name fn  in
                       key = uu____1300)))
             in
          let maybe_add_suffix f =
            if use_checked_file then cache_file_name f else f  in
          match d with
          | UseInterface key ->
              let uu____1319 = interface_of file_system_map key  in
              (match uu____1319 with
               | FStar_Pervasives_Native.None  ->
                   let uu____1326 =
                     let uu____1332 =
                       FStar_Util.format1
                         "Expected an interface for module %s, but couldn't find one"
                         key
                        in
                     (FStar_Errors.Fatal_MissingInterface, uu____1332)  in
                   FStar_Errors.raise_err uu____1326
               | FStar_Pervasives_Native.Some f -> f)
          | PreferInterface key when has_interface file_system_map key ->
              let uu____1342 =
                (cmd_line_has_impl key) &&
                  (let uu____1345 = FStar_Options.dep ()  in
                   FStar_Option.isNone uu____1345)
                 in
              if uu____1342
              then
                let uu____1352 = FStar_Options.expose_interfaces ()  in
                (if uu____1352
                 then
                   let uu____1356 =
                     let uu____1358 = implementation_of file_system_map key
                        in
                     FStar_Option.get uu____1358  in
                   maybe_add_suffix uu____1356
                 else
                   (let uu____1365 =
                      let uu____1371 =
                        let uu____1373 =
                          let uu____1375 =
                            implementation_of file_system_map key  in
                          FStar_Option.get uu____1375  in
                        let uu____1380 =
                          let uu____1382 = interface_of file_system_map key
                             in
                          FStar_Option.get uu____1382  in
                        FStar_Util.format3
                          "You may have a cyclic dependence on module %s: use --dep full to confirm. Alternatively, invoking fstar with %s on the command line breaks the abstraction imposed by its interface %s; if you really want this behavior add the option '--expose_interfaces'"
                          key uu____1373 uu____1380
                         in
                      (FStar_Errors.Fatal_MissingExposeInterfacesOption,
                        uu____1371)
                       in
                    FStar_Errors.raise_err uu____1365))
              else
                (let uu____1392 =
                   let uu____1394 = interface_of file_system_map key  in
                   FStar_Option.get uu____1394  in
                 maybe_add_suffix uu____1392)
          | PreferInterface key ->
              let uu____1401 = implementation_of file_system_map key  in
              (match uu____1401 with
               | FStar_Pervasives_Native.None  ->
                   let uu____1408 =
                     let uu____1414 =
                       FStar_Util.format1
                         "Expected an implementation of module %s, but couldn't find one"
                         key
                        in
                     (FStar_Errors.Fatal_MissingImplementation, uu____1414)
                      in
                   FStar_Errors.raise_err uu____1408
               | FStar_Pervasives_Native.Some f -> maybe_add_suffix f)
          | UseImplementation key ->
              let uu____1424 = implementation_of file_system_map key  in
              (match uu____1424 with
               | FStar_Pervasives_Native.None  ->
                   let uu____1431 =
                     let uu____1437 =
                       FStar_Util.format1
                         "Expected an implementation of module %s, but couldn't find one"
                         key
                        in
                     (FStar_Errors.Fatal_MissingImplementation, uu____1437)
                      in
                   FStar_Errors.raise_err uu____1431
               | FStar_Pervasives_Native.Some f -> maybe_add_suffix f)
          | FriendImplementation key ->
              let uu____1447 = implementation_of file_system_map key  in
              (match uu____1447 with
               | FStar_Pervasives_Native.None  ->
                   let uu____1454 =
                     let uu____1460 =
                       FStar_Util.format1
                         "Expected an implementation of module %s, but couldn't find one"
                         key
                        in
                     (FStar_Errors.Fatal_MissingImplementation, uu____1460)
                      in
                   FStar_Errors.raise_err uu____1454
               | FStar_Pervasives_Native.Some f -> maybe_add_suffix f)
  
let (file_of_dep :
  files_for_module_name -> file_name Prims.list -> dependence -> file_name) =
  file_of_dep_aux false 
let (dependences_of :
  files_for_module_name ->
    dependence_graph ->
      file_name Prims.list -> file_name -> file_name Prims.list)
  =
  fun file_system_map  ->
    fun deps  ->
      fun all_cmd_line_files  ->
        fun fn  ->
          let uu____1521 = deps_try_find deps fn  in
          match uu____1521 with
          | FStar_Pervasives_Native.None  -> empty_dependences ()
          | FStar_Pervasives_Native.Some (deps1,uu____1537) ->
              FStar_List.map (file_of_dep file_system_map all_cmd_line_files)
                deps1
  
let (print_graph : dependence_graph -> unit) =
  fun graph  ->
    FStar_Util.print_endline
      "A DOT-format graph has been dumped in the current directory as dep.graph";
    FStar_Util.print_endline
      "With GraphViz installed, try: fdp -Tpng -odep.png dep.graph";
    FStar_Util.print_endline
      "Hint: cat dep.graph | grep -v _ | grep -v prims";
    (let uu____1555 =
       let uu____1557 =
         let uu____1559 =
           let uu____1561 =
             let uu____1565 =
               let uu____1569 = deps_keys graph  in
               FStar_List.unique uu____1569  in
             FStar_List.collect
               (fun k  ->
                  let deps =
                    let uu____1583 =
                      let uu____1588 = deps_try_find graph k  in
                      FStar_Util.must uu____1588  in
                    FStar_Pervasives_Native.fst uu____1583  in
                  let r s = FStar_Util.replace_char s 46 95  in
                  let print7 dep1 =
                    FStar_Util.format2 "  \"%s\" -> \"%s\"" (r k)
                      (r (module_name_of_dep dep1))
                     in
                  FStar_List.map print7 deps) uu____1565
              in
           FStar_String.concat "\n" uu____1561  in
         Prims.strcat uu____1559 "\n}\n"  in
       Prims.strcat "digraph {\n" uu____1557  in
     FStar_Util.write_file "dep.graph" uu____1555)
  
let (build_inclusion_candidates_list :
  unit ->
    (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2 Prims.list)
  =
  fun uu____1636  ->
    let include_directories = FStar_Options.include_path ()  in
    let include_directories1 =
      FStar_List.map FStar_Util.normalize_file_path include_directories  in
    let include_directories2 = FStar_List.unique include_directories1  in
    let cwd =
      let uu____1662 = FStar_Util.getcwd ()  in
      FStar_Util.normalize_file_path uu____1662  in
    FStar_List.concatMap
      (fun d  ->
         if FStar_Util.is_directory d
         then
           let files = FStar_Util.readdir d  in
           FStar_List.filter_map
             (fun f  ->
                let f1 = FStar_Util.basename f  in
                let uu____1702 = check_and_strip_suffix f1  in
                FStar_All.pipe_right uu____1702
                  (FStar_Util.map_option
                     (fun longname  ->
                        let full_path =
                          if d = cwd then f1 else FStar_Util.join_paths d f1
                           in
                        (longname, full_path)))) files
         else
           (let uu____1739 =
              let uu____1745 =
                FStar_Util.format1 "not a valid include directory: %s\n" d
                 in
              (FStar_Errors.Fatal_NotValidIncludeDirectory, uu____1745)  in
            FStar_Errors.raise_err uu____1739)) include_directories2
  
let (build_map : Prims.string Prims.list -> files_for_module_name) =
  fun filenames  ->
    let map1 = FStar_Util.smap_create (Prims.parse_int "41")  in
    let add_entry key full_path =
      let uu____1808 = FStar_Util.smap_try_find map1 key  in
      match uu____1808 with
      | FStar_Pervasives_Native.Some (intf,impl) ->
          let uu____1855 = is_interface full_path  in
          if uu____1855
          then
            FStar_Util.smap_add map1 key
              ((FStar_Pervasives_Native.Some full_path), impl)
          else
            FStar_Util.smap_add map1 key
              (intf, (FStar_Pervasives_Native.Some full_path))
      | FStar_Pervasives_Native.None  ->
          let uu____1904 = is_interface full_path  in
          if uu____1904
          then
            FStar_Util.smap_add map1 key
              ((FStar_Pervasives_Native.Some full_path),
                FStar_Pervasives_Native.None)
          else
            FStar_Util.smap_add map1 key
              (FStar_Pervasives_Native.None,
                (FStar_Pervasives_Native.Some full_path))
       in
    (let uu____1946 = build_inclusion_candidates_list ()  in
     FStar_List.iter
       (fun uu____1964  ->
          match uu____1964 with
          | (longname,full_path) ->
              add_entry (FStar_String.lowercase longname) full_path)
       uu____1946);
    FStar_List.iter
      (fun f  ->
         let uu____1983 = lowercase_module_name f  in add_entry uu____1983 f)
      filenames;
    map1
  
let (enter_namespace :
  files_for_module_name ->
    files_for_module_name -> Prims.string -> Prims.bool)
  =
  fun original_map  ->
    fun working_map  ->
      fun prefix1  ->
        let found = FStar_Util.mk_ref false  in
        let prefix2 = Prims.strcat prefix1 "."  in
        (let uu____2015 =
           let uu____2019 = FStar_Util.smap_keys original_map  in
           FStar_List.unique uu____2019  in
         FStar_List.iter
           (fun k  ->
              if FStar_Util.starts_with k prefix2
              then
                let suffix =
                  FStar_String.substring k (FStar_String.length prefix2)
                    ((FStar_String.length k) - (FStar_String.length prefix2))
                   in
                let filename =
                  let uu____2055 = FStar_Util.smap_try_find original_map k
                     in
                  FStar_Util.must uu____2055  in
                (FStar_Util.smap_add working_map suffix filename;
                 FStar_ST.op_Colon_Equals found true)
              else ()) uu____2015);
        FStar_ST.op_Bang found
  
let (string_of_lid : FStar_Ident.lident -> Prims.bool -> Prims.string) =
  fun l  ->
    fun last1  ->
      let suffix =
        if last1 then [(l.FStar_Ident.ident).FStar_Ident.idText] else []  in
      let names =
        let uu____2219 =
          FStar_List.map (fun x  -> x.FStar_Ident.idText) l.FStar_Ident.ns
           in
        FStar_List.append uu____2219 suffix  in
      FStar_String.concat "." names
  
let (lowercase_join_longident :
  FStar_Ident.lident -> Prims.bool -> Prims.string) =
  fun l  ->
    fun last1  ->
      let uu____2242 = string_of_lid l last1  in
      FStar_String.lowercase uu____2242
  
let (namespace_of_lid : FStar_Ident.lident -> Prims.string) =
  fun l  ->
    let uu____2251 = FStar_List.map FStar_Ident.text_of_id l.FStar_Ident.ns
       in
    FStar_String.concat "_" uu____2251
  
let (check_module_declaration_against_filename :
  FStar_Ident.lident -> Prims.string -> unit) =
  fun lid  ->
    fun filename  ->
      let k' = lowercase_join_longident lid true  in
      let uu____2273 =
        let uu____2275 =
          let uu____2277 =
            let uu____2279 =
              let uu____2283 = FStar_Util.basename filename  in
              check_and_strip_suffix uu____2283  in
            FStar_Util.must uu____2279  in
          FStar_String.lowercase uu____2277  in
        uu____2275 <> k'  in
      if uu____2273
      then
        let uu____2288 = FStar_Ident.range_of_lid lid  in
        let uu____2289 =
          let uu____2295 =
            let uu____2297 = string_of_lid lid true  in
            FStar_Util.format2
              "The module declaration \"module %s\" found in file %s does not match its filename. Dependencies will be incorrect and the module will not be verified.\n"
              uu____2297 filename
             in
          (FStar_Errors.Error_ModuleFileNameMismatch, uu____2295)  in
        FStar_Errors.log_issue uu____2288 uu____2289
      else ()
  
exception Exit 
let (uu___is_Exit : Prims.exn -> Prims.bool) =
  fun projectee  ->
    match projectee with | Exit  -> true | uu____2313 -> false
  
let (hard_coded_dependencies :
  Prims.string ->
    (FStar_Ident.lident,open_kind) FStar_Pervasives_Native.tuple2 Prims.list)
  =
  fun full_filename  ->
    let filename = FStar_Util.basename full_filename  in
    let corelibs =
      let uu____2335 = FStar_Options.prims_basename ()  in
      let uu____2337 =
        let uu____2341 = FStar_Options.pervasives_basename ()  in
        let uu____2343 =
          let uu____2347 = FStar_Options.pervasives_native_basename ()  in
          [uu____2347]  in
        uu____2341 :: uu____2343  in
      uu____2335 :: uu____2337  in
    if FStar_List.mem filename corelibs
    then []
    else
      (let implicit_deps =
         [(FStar_Parser_Const.fstar_ns_lid, Open_namespace);
         (FStar_Parser_Const.prims_lid, Open_module);
         (FStar_Parser_Const.pervasives_lid, Open_module)]  in
       let uu____2390 =
         let uu____2393 = lowercase_module_name full_filename  in
         namespace_of_module uu____2393  in
       match uu____2390 with
       | FStar_Pervasives_Native.None  -> implicit_deps
       | FStar_Pervasives_Native.Some ns ->
           FStar_List.append implicit_deps [(ns, Open_namespace)])
  
let (dep_subsumed_by : dependence -> dependence -> Prims.bool) =
  fun d  ->
    fun d'  ->
      match (d, d') with
      | (PreferInterface l',FriendImplementation l) -> l = l'
      | uu____2432 -> d = d'
  
let (collect_one :
  files_for_module_name ->
    Prims.string ->
      (dependence Prims.list,dependence Prims.list,Prims.bool)
        FStar_Pervasives_Native.tuple3)
  =
  fun original_map  ->
    fun filename  ->
      let deps = FStar_Util.mk_ref []  in
      let mo_roots = FStar_Util.mk_ref []  in
      let has_inline_for_extraction = FStar_Util.mk_ref false  in
      let set_interface_inlining uu____2497 =
        let uu____2498 = is_interface filename  in
        if uu____2498
        then FStar_ST.op_Colon_Equals has_inline_for_extraction true
        else ()  in
      let add_dep deps1 d =
        let uu____2705 =
          let uu____2707 =
            let uu____2709 = FStar_ST.op_Bang deps1  in
            FStar_List.existsML (dep_subsumed_by d) uu____2709  in
          Prims.op_Negation uu____2707  in
        if uu____2705
        then
          let uu____2778 =
            let uu____2781 = FStar_ST.op_Bang deps1  in d :: uu____2781  in
          FStar_ST.op_Colon_Equals deps1 uu____2778
        else ()  in
      let working_map = FStar_Util.smap_copy original_map  in
      let dep_edge module_name = PreferInterface module_name  in
      let add_dependence_edge original_or_working_map lid =
        let key = lowercase_join_longident lid true  in
        let uu____2962 = resolve_module_name original_or_working_map key  in
        match uu____2962 with
        | FStar_Pervasives_Native.Some module_name ->
            (add_dep deps (dep_edge module_name);
             (let uu____3005 =
                (has_interface original_or_working_map module_name) &&
                  (has_implementation original_or_working_map module_name)
                 in
              if uu____3005
              then add_dep mo_roots (UseImplementation module_name)
              else ());
             true)
        | uu____3044 -> false  in
      let record_open_module let_open lid =
        let uu____3063 =
          (let_open && (add_dependence_edge working_map lid)) ||
            ((Prims.op_Negation let_open) &&
               (add_dependence_edge original_map lid))
           in
        if uu____3063
        then true
        else
          (if let_open
           then
             (let uu____3072 = FStar_Ident.range_of_lid lid  in
              let uu____3073 =
                let uu____3079 =
                  let uu____3081 = string_of_lid lid true  in
                  FStar_Util.format1 "Module not found: %s" uu____3081  in
                (FStar_Errors.Warning_ModuleOrFileNotFoundWarning,
                  uu____3079)
                 in
              FStar_Errors.log_issue uu____3072 uu____3073)
           else ();
           false)
         in
      let record_open_namespace lid =
        let key = lowercase_join_longident lid true  in
        let r = enter_namespace original_map working_map key  in
        if Prims.op_Negation r
        then
          let uu____3101 = FStar_Ident.range_of_lid lid  in
          let uu____3102 =
            let uu____3108 =
              let uu____3110 = string_of_lid lid true  in
              FStar_Util.format1
                "No modules in namespace %s and no file with that name either"
                uu____3110
               in
            (FStar_Errors.Warning_ModuleOrFileNotFoundWarning, uu____3108)
             in
          FStar_Errors.log_issue uu____3101 uu____3102
        else ()  in
      let record_open let_open lid =
        let uu____3130 = record_open_module let_open lid  in
        if uu____3130
        then ()
        else
          if Prims.op_Negation let_open
          then record_open_namespace lid
          else ()
         in
      let record_open_module_or_namespace uu____3147 =
        match uu____3147 with
        | (lid,kind) ->
            (match kind with
             | Open_namespace  -> record_open_namespace lid
             | Open_module  ->
                 let uu____3154 = record_open_module false lid  in ())
         in
      let record_module_alias ident lid =
        let key =
          let uu____3171 = FStar_Ident.text_of_id ident  in
          FStar_String.lowercase uu____3171  in
        let alias = lowercase_join_longident lid true  in
        let uu____3176 = FStar_Util.smap_try_find original_map alias  in
        match uu____3176 with
        | FStar_Pervasives_Native.Some deps_of_aliased_module ->
            (FStar_Util.smap_add working_map key deps_of_aliased_module; true)
        | FStar_Pervasives_Native.None  ->
            ((let uu____3244 = FStar_Ident.range_of_lid lid  in
              let uu____3245 =
                let uu____3251 =
                  FStar_Util.format1 "module not found in search path: %s\n"
                    alias
                   in
                (FStar_Errors.Warning_ModuleOrFileNotFoundWarning,
                  uu____3251)
                 in
              FStar_Errors.log_issue uu____3244 uu____3245);
             false)
         in
      let record_lid lid =
        match lid.FStar_Ident.ns with
        | [] -> ()
        | uu____3262 ->
            let module_name = FStar_Ident.lid_of_ids lid.FStar_Ident.ns  in
            let uu____3266 = add_dependence_edge working_map module_name  in
            if uu____3266
            then ()
            else
              (let uu____3271 = FStar_Options.debug_any ()  in
               if uu____3271
               then
                 let uu____3274 = FStar_Ident.range_of_lid lid  in
                 let uu____3275 =
                   let uu____3281 =
                     let uu____3283 = FStar_Ident.string_of_lid module_name
                        in
                     FStar_Util.format1 "Unbound module reference %s"
                       uu____3283
                      in
                   (FStar_Errors.Warning_UnboundModuleReference, uu____3281)
                    in
                 FStar_Errors.log_issue uu____3274 uu____3275
               else ())
         in
      let auto_open = hard_coded_dependencies filename  in
      FStar_List.iter record_open_module_or_namespace auto_open;
      (let num_of_toplevelmods = FStar_Util.mk_ref (Prims.parse_int "0")  in
       let rec collect_module uu___118_3413 =
         match uu___118_3413 with
         | FStar_Parser_AST.Module (lid,decls) ->
             (check_module_declaration_against_filename lid filename;
              if
                (FStar_List.length lid.FStar_Ident.ns) >
                  (Prims.parse_int "0")
              then
                (let uu____3424 =
                   let uu____3426 = namespace_of_lid lid  in
                   enter_namespace original_map working_map uu____3426  in
                 ())
              else ();
              collect_decls decls)
         | FStar_Parser_AST.Interface (lid,decls,uu____3432) ->
             (check_module_declaration_against_filename lid filename;
              if
                (FStar_List.length lid.FStar_Ident.ns) >
                  (Prims.parse_int "0")
              then
                (let uu____3443 =
                   let uu____3445 = namespace_of_lid lid  in
                   enter_namespace original_map working_map uu____3445  in
                 ())
              else ();
              collect_decls decls)
       
       and collect_decls decls =
         FStar_List.iter
           (fun x  ->
              collect_decl x.FStar_Parser_AST.d;
              FStar_List.iter collect_term x.FStar_Parser_AST.attrs;
              if
                FStar_List.contains FStar_Parser_AST.Inline_for_extraction
                  x.FStar_Parser_AST.quals
              then set_interface_inlining ()
              else ()) decls
       
       and collect_decl d =
         match d with
         | FStar_Parser_AST.Include lid -> record_open false lid
         | FStar_Parser_AST.Open lid -> record_open false lid
         | FStar_Parser_AST.Friend lid ->
             let uu____3467 =
               let uu____3468 = lowercase_join_longident lid true  in
               FriendImplementation uu____3468  in
             add_dep deps uu____3467
         | FStar_Parser_AST.ModuleAbbrev (ident,lid) ->
             let uu____3506 = record_module_alias ident lid  in
             if uu____3506
             then
               let uu____3509 =
                 let uu____3510 = lowercase_join_longident lid true  in
                 dep_edge uu____3510  in
               add_dep deps uu____3509
             else ()
         | FStar_Parser_AST.TopLevelLet (uu____3548,patterms) ->
             FStar_List.iter
               (fun uu____3570  ->
                  match uu____3570 with
                  | (pat,t) -> (collect_pattern pat; collect_term t))
               patterms
         | FStar_Parser_AST.Main t -> collect_term t
         | FStar_Parser_AST.Splice (uu____3579,t) -> collect_term t
         | FStar_Parser_AST.Assume (uu____3585,t) -> collect_term t
         | FStar_Parser_AST.SubEffect
             { FStar_Parser_AST.msource = uu____3587;
               FStar_Parser_AST.mdest = uu____3588;
               FStar_Parser_AST.lift_op = FStar_Parser_AST.NonReifiableLift t;_}
             -> collect_term t
         | FStar_Parser_AST.SubEffect
             { FStar_Parser_AST.msource = uu____3590;
               FStar_Parser_AST.mdest = uu____3591;
               FStar_Parser_AST.lift_op = FStar_Parser_AST.LiftForFree t;_}
             -> collect_term t
         | FStar_Parser_AST.Val (uu____3593,t) -> collect_term t
         | FStar_Parser_AST.SubEffect
             { FStar_Parser_AST.msource = uu____3595;
               FStar_Parser_AST.mdest = uu____3596;
               FStar_Parser_AST.lift_op = FStar_Parser_AST.ReifiableLift
                 (t0,t1);_}
             -> (collect_term t0; collect_term t1)
         | FStar_Parser_AST.Tycon (uu____3600,tc,ts) ->
             (if tc then record_lid FStar_Parser_Const.mk_class_lid else ();
              (let ts1 =
                 FStar_List.map
                   (fun uu____3639  ->
                      match uu____3639 with | (x,docnik) -> x) ts
                  in
               FStar_List.iter collect_tycon ts1))
         | FStar_Parser_AST.Exception (uu____3652,t) ->
             FStar_Util.iter_opt t collect_term
         | FStar_Parser_AST.NewEffect ed -> collect_effect_decl ed
         | FStar_Parser_AST.Fsdoc uu____3659 -> ()
         | FStar_Parser_AST.Pragma uu____3660 -> ()
         | FStar_Parser_AST.TopLevelModule lid ->
             (FStar_Util.incr num_of_toplevelmods;
              (let uu____3696 =
                 let uu____3698 = FStar_ST.op_Bang num_of_toplevelmods  in
                 uu____3698 > (Prims.parse_int "1")  in
               if uu____3696
               then
                 let uu____3745 =
                   let uu____3751 =
                     let uu____3753 = string_of_lid lid true  in
                     FStar_Util.format1
                       "Automatic dependency analysis demands one module per file (module %s not supported)"
                       uu____3753
                      in
                   (FStar_Errors.Fatal_OneModulePerFile, uu____3751)  in
                 let uu____3758 = FStar_Ident.range_of_lid lid  in
                 FStar_Errors.raise_error uu____3745 uu____3758
               else ()))
       
       and collect_tycon uu___119_3761 =
         match uu___119_3761 with
         | FStar_Parser_AST.TyconAbstract (uu____3762,binders,k) ->
             (collect_binders binders; FStar_Util.iter_opt k collect_term)
         | FStar_Parser_AST.TyconAbbrev (uu____3774,binders,k,t) ->
             (collect_binders binders;
              FStar_Util.iter_opt k collect_term;
              collect_term t)
         | FStar_Parser_AST.TyconRecord (uu____3788,binders,k,identterms) ->
             (collect_binders binders;
              FStar_Util.iter_opt k collect_term;
              FStar_List.iter
                (fun uu____3834  ->
                   match uu____3834 with
                   | (uu____3843,t,uu____3845) -> collect_term t) identterms)
         | FStar_Parser_AST.TyconVariant (uu____3850,binders,k,identterms) ->
             (collect_binders binders;
              FStar_Util.iter_opt k collect_term;
              FStar_List.iter
                (fun uu____3912  ->
                   match uu____3912 with
                   | (uu____3926,t,uu____3928,uu____3929) ->
                       FStar_Util.iter_opt t collect_term) identterms)
       
       and collect_effect_decl uu___120_3940 =
         match uu___120_3940 with
         | FStar_Parser_AST.DefineEffect (uu____3941,binders,t,decls) ->
             (collect_binders binders; collect_term t; collect_decls decls)
         | FStar_Parser_AST.RedefineEffect (uu____3955,binders,t) ->
             (collect_binders binders; collect_term t)
       
       and collect_binders binders = FStar_List.iter collect_binder binders
       
       and collect_binder b =
         collect_aqual b.FStar_Parser_AST.aqual;
         (match b with
          | { FStar_Parser_AST.b = FStar_Parser_AST.Annotated (uu____3968,t);
              FStar_Parser_AST.brange = uu____3970;
              FStar_Parser_AST.blevel = uu____3971;
              FStar_Parser_AST.aqual = uu____3972;_} -> collect_term t
          | {
              FStar_Parser_AST.b = FStar_Parser_AST.TAnnotated (uu____3975,t);
              FStar_Parser_AST.brange = uu____3977;
              FStar_Parser_AST.blevel = uu____3978;
              FStar_Parser_AST.aqual = uu____3979;_} -> collect_term t
          | { FStar_Parser_AST.b = FStar_Parser_AST.NoName t;
              FStar_Parser_AST.brange = uu____3983;
              FStar_Parser_AST.blevel = uu____3984;
              FStar_Parser_AST.aqual = uu____3985;_} -> collect_term t
          | uu____3988 -> ())
       
       and collect_aqual uu___121_3989 =
         match uu___121_3989 with
         | FStar_Pervasives_Native.Some (FStar_Parser_AST.Meta t) ->
             collect_term t
         | uu____3993 -> ()
       
       and collect_term t = collect_term' t.FStar_Parser_AST.tm
       
       and collect_constant uu___122_3997 =
         match uu___122_3997 with
         | FStar_Const.Const_int
             (uu____3998,FStar_Pervasives_Native.Some (signedness,width)) ->
             let u =
               match signedness with
               | FStar_Const.Unsigned  -> "u"
               | FStar_Const.Signed  -> ""  in
             let w =
               match width with
               | FStar_Const.Int8  -> "8"
               | FStar_Const.Int16  -> "16"
               | FStar_Const.Int32  -> "32"
               | FStar_Const.Int64  -> "64"  in
             let uu____4025 =
               let uu____4026 = FStar_Util.format2 "fstar.%sint%s" u w  in
               dep_edge uu____4026  in
             add_dep deps uu____4025
         | FStar_Const.Const_char uu____4062 ->
             add_dep deps (dep_edge "fstar.char")
         | FStar_Const.Const_float uu____4098 ->
             add_dep deps (dep_edge "fstar.float")
         | uu____4133 -> ()
       
       and collect_term' uu___124_4134 =
         match uu___124_4134 with
         | FStar_Parser_AST.Wild  -> ()
         | FStar_Parser_AST.Const c -> collect_constant c
         | FStar_Parser_AST.Op (s,ts) ->
             ((let uu____4143 =
                 let uu____4145 = FStar_Ident.text_of_id s  in
                 uu____4145 = "@"  in
               if uu____4143
               then
                 let uu____4150 =
                   let uu____4151 =
                     let uu____4152 =
                       FStar_Ident.path_of_text "FStar.List.Tot.Base.append"
                        in
                     FStar_Ident.lid_of_path uu____4152
                       FStar_Range.dummyRange
                      in
                   FStar_Parser_AST.Name uu____4151  in
                 collect_term' uu____4150
               else ());
              FStar_List.iter collect_term ts)
         | FStar_Parser_AST.Tvar uu____4156 -> ()
         | FStar_Parser_AST.Uvar uu____4157 -> ()
         | FStar_Parser_AST.Var lid -> record_lid lid
         | FStar_Parser_AST.Projector (lid,uu____4160) -> record_lid lid
         | FStar_Parser_AST.Discrim lid -> record_lid lid
         | FStar_Parser_AST.Name lid -> record_lid lid
         | FStar_Parser_AST.Construct (lid,termimps) ->
             (if (FStar_List.length termimps) = (Prims.parse_int "1")
              then record_lid lid
              else ();
              FStar_List.iter
                (fun uu____4194  ->
                   match uu____4194 with | (t,uu____4200) -> collect_term t)
                termimps)
         | FStar_Parser_AST.Abs (pats,t) ->
             (collect_patterns pats; collect_term t)
         | FStar_Parser_AST.App (t1,t2,uu____4210) ->
             (collect_term t1; collect_term t2)
         | FStar_Parser_AST.Let (uu____4212,patterms,t) ->
             (FStar_List.iter
                (fun uu____4262  ->
                   match uu____4262 with
                   | (attrs_opt,(pat,t1)) ->
                       ((let uu____4291 =
                           FStar_Util.map_opt attrs_opt
                             (FStar_List.iter collect_term)
                            in
                         ());
                        collect_pattern pat;
                        collect_term t1)) patterms;
              collect_term t)
         | FStar_Parser_AST.LetOpen (lid,t) ->
             (record_open true lid; collect_term t)
         | FStar_Parser_AST.Bind (uu____4301,t1,t2) ->
             (collect_term t1; collect_term t2)
         | FStar_Parser_AST.Seq (t1,t2) -> (collect_term t1; collect_term t2)
         | FStar_Parser_AST.If (t1,t2,t3) ->
             (collect_term t1; collect_term t2; collect_term t3)
         | FStar_Parser_AST.Match (t,bs) ->
             (collect_term t; collect_branches bs)
         | FStar_Parser_AST.TryWith (t,bs) ->
             (collect_term t; collect_branches bs)
         | FStar_Parser_AST.Ascribed (t1,t2,FStar_Pervasives_Native.None ) ->
             (collect_term t1; collect_term t2)
         | FStar_Parser_AST.Ascribed (t1,t2,FStar_Pervasives_Native.Some tac)
             -> (collect_term t1; collect_term t2; collect_term tac)
         | FStar_Parser_AST.Record (t,idterms) ->
             (FStar_Util.iter_opt t collect_term;
              FStar_List.iter
                (fun uu____4397  ->
                   match uu____4397 with | (uu____4402,t1) -> collect_term t1)
                idterms)
         | FStar_Parser_AST.Project (t,uu____4405) -> collect_term t
         | FStar_Parser_AST.Product (binders,t) ->
             (collect_binders binders; collect_term t)
         | FStar_Parser_AST.Sum (binders,t) ->
             (FStar_List.iter
                (fun uu___123_4434  ->
                   match uu___123_4434 with
                   | FStar_Util.Inl b -> collect_binder b
                   | FStar_Util.Inr t1 -> collect_term t1) binders;
              collect_term t)
         | FStar_Parser_AST.QForall (binders,ts,t) ->
             (collect_binders binders;
              FStar_List.iter (FStar_List.iter collect_term) ts;
              collect_term t)
         | FStar_Parser_AST.QExists (binders,ts,t) ->
             (collect_binders binders;
              FStar_List.iter (FStar_List.iter collect_term) ts;
              collect_term t)
         | FStar_Parser_AST.Refine (binder,t) ->
             (collect_binder binder; collect_term t)
         | FStar_Parser_AST.NamedTyp (uu____4482,t) -> collect_term t
         | FStar_Parser_AST.Paren t -> collect_term t
         | FStar_Parser_AST.Requires (t,uu____4486) -> collect_term t
         | FStar_Parser_AST.Ensures (t,uu____4494) -> collect_term t
         | FStar_Parser_AST.Labeled (t,uu____4502,uu____4503) ->
             collect_term t
         | FStar_Parser_AST.Quote (t,uu____4509) -> collect_term t
         | FStar_Parser_AST.Antiquote t -> collect_term t
         | FStar_Parser_AST.VQuote t -> collect_term t
         | FStar_Parser_AST.Attributes cattributes ->
             FStar_List.iter collect_term cattributes
       
       and collect_patterns ps = FStar_List.iter collect_pattern ps
       
       and collect_pattern p = collect_pattern' p.FStar_Parser_AST.pat
       
       and collect_pattern' uu___125_4519 =
         match uu___125_4519 with
         | FStar_Parser_AST.PatVar (uu____4520,aqual) -> collect_aqual aqual
         | FStar_Parser_AST.PatTvar (uu____4526,aqual) -> collect_aqual aqual
         | FStar_Parser_AST.PatWild aqual -> collect_aqual aqual
         | FStar_Parser_AST.PatOp uu____4535 -> ()
         | FStar_Parser_AST.PatConst uu____4536 -> ()
         | FStar_Parser_AST.PatApp (p,ps) ->
             (collect_pattern p; collect_patterns ps)
         | FStar_Parser_AST.PatName uu____4544 -> ()
         | FStar_Parser_AST.PatList ps -> collect_patterns ps
         | FStar_Parser_AST.PatOr ps -> collect_patterns ps
         | FStar_Parser_AST.PatTuple (ps,uu____4552) -> collect_patterns ps
         | FStar_Parser_AST.PatRecord lidpats ->
             FStar_List.iter
               (fun uu____4573  ->
                  match uu____4573 with | (uu____4578,p) -> collect_pattern p)
               lidpats
         | FStar_Parser_AST.PatAscribed (p,(t,FStar_Pervasives_Native.None ))
             -> (collect_pattern p; collect_term t)
         | FStar_Parser_AST.PatAscribed
             (p,(t,FStar_Pervasives_Native.Some tac)) ->
             (collect_pattern p; collect_term t; collect_term tac)
       
       and collect_branches bs = FStar_List.iter collect_branch bs
       
       and collect_branch uu____4623 =
         match uu____4623 with
         | (pat,t1,t2) ->
             (collect_pattern pat;
              FStar_Util.iter_opt t1 collect_term;
              collect_term t2)
        in
       let uu____4641 = FStar_Parser_Driver.parse_file filename  in
       match uu____4641 with
       | (ast,uu____4665) ->
           let mname = lowercase_module_name filename  in
           ((let uu____4683 =
               (is_interface filename) &&
                 (has_implementation original_map mname)
                in
             if uu____4683
             then add_dep mo_roots (UseImplementation mname)
             else ());
            collect_module ast;
            (let uu____4722 = FStar_ST.op_Bang deps  in
             let uu____4770 = FStar_ST.op_Bang mo_roots  in
             let uu____4818 = FStar_ST.op_Bang has_inline_for_extraction  in
             (uu____4722, uu____4770, uu____4818))))
  
let (collect_one_cache :
  (dependence Prims.list,dependence Prims.list,Prims.bool)
    FStar_Pervasives_Native.tuple3 FStar_Util.smap FStar_ST.ref)
  =
  let uu____4895 = FStar_Util.smap_create (Prims.parse_int "0")  in
  FStar_Util.mk_ref uu____4895 
let (set_collect_one_cache :
  (dependence Prims.list,dependence Prims.list,Prims.bool)
    FStar_Pervasives_Native.tuple3 FStar_Util.smap -> unit)
  = fun cache  -> FStar_ST.op_Colon_Equals collect_one_cache cache 
let (dep_graph_copy : dependence_graph -> dependence_graph) =
  fun dep_graph  ->
    let uu____5017 = dep_graph  in
    match uu____5017 with
    | Deps g -> let uu____5025 = FStar_Util.smap_copy g  in Deps uu____5025
  
let (topological_dependences_of :
  files_for_module_name ->
    dependence_graph ->
      module_name Prims.list ->
        file_name Prims.list ->
          Prims.bool ->
            (file_name Prims.list,Prims.bool) FStar_Pervasives_Native.tuple2)
  =
  fun file_system_map  ->
    fun dep_graph  ->
      fun interfaces_needing_inlining  ->
        fun root_files  ->
          fun for_extraction  ->
            let rec all_friend_deps_1 dep_graph1 cycle uu____5174 filename =
              match uu____5174 with
              | (all_friends,all_files) ->
                  let uu____5210 =
                    let uu____5215 = deps_try_find dep_graph1 filename  in
                    FStar_Util.must uu____5215  in
                  (match uu____5210 with
                   | (direct_deps,color) ->
                       (match color with
                        | Gray  ->
                            failwith
                              "Impossible: cycle detected after cycle detection has passed"
                        | Black  -> (all_friends, all_files)
                        | White  ->
                            (deps_add_dep dep_graph1 filename
                               (direct_deps, Gray);
                             (let uu____5262 =
                                let uu____5272 =
                                  dependences_of file_system_map dep_graph1
                                    root_files filename
                                   in
                                all_friend_deps dep_graph1 cycle
                                  (all_friends, all_files) uu____5272
                                 in
                              match uu____5262 with
                              | (all_friends1,all_files1) ->
                                  (deps_add_dep dep_graph1 filename
                                     (direct_deps, Black);
                                   (let uu____5303 =
                                      let uu____5306 =
                                        FStar_List.filter
                                          (fun uu___126_5311  ->
                                             match uu___126_5311 with
                                             | FriendImplementation
                                                 uu____5313 -> true
                                             | uu____5316 -> false)
                                          direct_deps
                                         in
                                      FStar_List.append uu____5306
                                        all_friends1
                                       in
                                    (uu____5303, (filename :: all_files1))))))))
            
            and all_friend_deps dep_graph1 cycle all_friends filenames =
              FStar_List.fold_left
                (fun all_friends1  ->
                   fun k  ->
                     all_friend_deps_1 dep_graph1 (k :: cycle) all_friends1 k)
                all_friends filenames
             in
            let uu____5368 =
              let uu____5378 = dep_graph_copy dep_graph  in
              all_friend_deps uu____5378 [] ([], []) root_files  in
            match uu____5368 with
            | (friends,uu____5395) ->
                let widened = FStar_Util.mk_ref false  in
                let widen_deps friends1 deps =
                  FStar_All.pipe_right deps
                    (FStar_List.map
                       (fun d  ->
                          match d with
                          | PreferInterface f when
                              (FStar_Options.cmi ()) && for_extraction ->
                              let uu____5444 =
                                (has_implementation file_system_map f) &&
                                  (FStar_List.contains f
                                     interfaces_needing_inlining)
                                 in
                              if uu____5444
                              then
                                (FStar_ST.op_Colon_Equals widened true;
                                 UseImplementation f)
                              else PreferInterface f
                          | PreferInterface f when
                              FStar_List.contains (FriendImplementation f)
                                friends1
                              -> FriendImplementation f
                          | uu____5497 -> d))
                   in
                let uu____5498 =
                  let uu____5508 = dep_graph  in
                  match uu____5508 with
                  | Deps dg ->
                      let uu____5525 = deps_empty ()  in
                      (match uu____5525 with
                       | Deps dg' ->
                           (FStar_Util.smap_fold dg
                              (fun filename  ->
                                 fun uu____5554  ->
                                   fun uu____5555  ->
                                     match uu____5554 with
                                     | (dependences,color) ->
                                         let uu____5563 =
                                           let uu____5568 =
                                             widen_deps friends dependences
                                              in
                                           (uu____5568, color)  in
                                         FStar_Util.smap_add dg' filename
                                           uu____5563) ();
                            all_friend_deps (Deps dg') [] ([], []) root_files))
                   in
                (match uu____5498 with
                 | (uu____5588,all_files) ->
                     let uu____5600 = FStar_ST.op_Bang widened  in
                     (all_files, uu____5600))
  
let (collect :
  Prims.string Prims.list ->
    (Prims.string Prims.list,deps) FStar_Pervasives_Native.tuple2)
  =
  fun all_cmd_line_files  ->
    let all_cmd_line_files1 =
      FStar_All.pipe_right all_cmd_line_files
        (FStar_List.map
           (fun fn  ->
              let uu____5692 = FStar_Options.find_file fn  in
              match uu____5692 with
              | FStar_Pervasives_Native.None  ->
                  let uu____5698 =
                    let uu____5704 =
                      FStar_Util.format1 "File %s could not be found\n" fn
                       in
                    (FStar_Errors.Fatal_ModuleOrFileNotFound, uu____5704)  in
                  FStar_Errors.raise_err uu____5698
              | FStar_Pervasives_Native.Some fn1 -> fn1))
       in
    let dep_graph = deps_empty ()  in
    let file_system_map = build_map all_cmd_line_files1  in
    let interfaces_needing_inlining = FStar_Util.mk_ref []  in
    let add_interface_for_inlining l =
      let l1 = lowercase_module_name l  in
      let uu____5734 =
        let uu____5738 = FStar_ST.op_Bang interfaces_needing_inlining  in l1
          :: uu____5738
         in
      FStar_ST.op_Colon_Equals interfaces_needing_inlining uu____5734  in
    let rec discover_one file_name =
      let uu____5845 =
        let uu____5847 = deps_try_find dep_graph file_name  in
        uu____5847 = FStar_Pervasives_Native.None  in
      if uu____5845
      then
        let uu____5865 =
          let uu____5877 =
            let uu____5891 = FStar_ST.op_Bang collect_one_cache  in
            FStar_Util.smap_try_find uu____5891 file_name  in
          match uu____5877 with
          | FStar_Pervasives_Native.Some cached -> cached
          | FStar_Pervasives_Native.None  ->
              collect_one file_system_map file_name
           in
        match uu____5865 with
        | (deps,mo_roots,needs_interface_inlining) ->
            (if needs_interface_inlining
             then add_interface_for_inlining file_name
             else ();
             (let deps1 =
                let module_name = lowercase_module_name file_name  in
                let uu____6028 =
                  (is_implementation file_name) &&
                    (has_interface file_system_map module_name)
                   in
                if uu____6028
                then FStar_List.append deps [UseInterface module_name]
                else deps  in
              (let uu____6036 =
                 let uu____6041 = FStar_List.unique deps1  in
                 (uu____6041, White)  in
               deps_add_dep dep_graph file_name uu____6036);
              (let uu____6042 =
                 FStar_List.map
                   (file_of_dep file_system_map all_cmd_line_files1)
                   (FStar_List.append deps1 mo_roots)
                  in
               FStar_List.iter discover_one uu____6042)))
      else ()  in
    FStar_List.iter discover_one all_cmd_line_files1;
    (let cycle_detected dep_graph1 cycle filename =
       FStar_Util.print1
         "The cycle contains a subset of the modules in:\n%s \n"
         (FStar_String.concat "\n`used by` " cycle);
       print_graph dep_graph1;
       FStar_Util.print_string "\n";
       (let uu____6082 =
          let uu____6088 =
            FStar_Util.format1 "Recursive dependency on module %s\n" filename
             in
          (FStar_Errors.Fatal_CyclicDependence, uu____6088)  in
        FStar_Errors.raise_err uu____6082)
        in
     let full_cycle_detection all_command_line_files =
       let dep_graph1 = dep_graph_copy dep_graph  in
       let rec aux cycle filename =
         let uu____6124 =
           let uu____6131 = deps_try_find dep_graph1 filename  in
           match uu____6131 with
           | FStar_Pervasives_Native.Some (d,c) -> (d, c)
           | FStar_Pervasives_Native.None  ->
               let uu____6156 =
                 FStar_Util.format1 "Failed to find dependences of %s"
                   filename
                  in
               failwith uu____6156
            in
         match uu____6124 with
         | (direct_deps,color) ->
             let direct_deps1 =
               FStar_All.pipe_right direct_deps
                 (FStar_List.collect
                    (fun x  ->
                       match x with
                       | UseInterface f ->
                           let uu____6182 =
                             implementation_of file_system_map f  in
                           (match uu____6182 with
                            | FStar_Pervasives_Native.None  -> [x]
                            | FStar_Pervasives_Native.Some fn when
                                fn = filename -> [x]
                            | uu____6193 -> [x; UseImplementation f])
                       | PreferInterface f ->
                           let uu____6199 =
                             implementation_of file_system_map f  in
                           (match uu____6199 with
                            | FStar_Pervasives_Native.None  -> [x]
                            | FStar_Pervasives_Native.Some fn when
                                fn = filename -> [x]
                            | uu____6210 -> [x; UseImplementation f])
                       | uu____6214 -> [x]))
                in
             (match color with
              | Gray  -> cycle_detected dep_graph1 cycle filename
              | Black  -> ()
              | White  ->
                  (deps_add_dep dep_graph1 filename (direct_deps1, Gray);
                   (let uu____6217 =
                      dependences_of file_system_map dep_graph1
                        all_command_line_files filename
                       in
                    FStar_List.iter (fun k  -> aux (k :: cycle) k) uu____6217);
                   deps_add_dep dep_graph1 filename (direct_deps1, Black)))
          in
       FStar_List.iter (aux []) all_command_line_files  in
     full_cycle_detection all_cmd_line_files1;
     FStar_All.pipe_right all_cmd_line_files1
       (FStar_List.iter
          (fun f  ->
             let m = lowercase_module_name f  in
             FStar_Options.add_verify_module m));
     (let inlining_ifaces = FStar_ST.op_Bang interfaces_needing_inlining  in
      let uu____6291 =
        let uu____6300 =
          let uu____6302 = FStar_Options.codegen ()  in
          uu____6302 <> FStar_Pervasives_Native.None  in
        topological_dependences_of file_system_map dep_graph inlining_ifaces
          all_cmd_line_files1 uu____6300
         in
      match uu____6291 with
      | (all_files,uu____6315) ->
          (all_files,
            (mk_deps dep_graph file_system_map all_cmd_line_files1 all_files
               inlining_ifaces))))
  
let (deps_of : deps -> Prims.string -> Prims.string Prims.list) =
  fun deps  ->
    fun f  ->
      dependences_of deps.file_system_map deps.dep_graph deps.cmd_line_files
        f
  
let (hash_dependences :
  deps ->
    Prims.string ->
      (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2 Prims.list
        FStar_Pervasives_Native.option)
  =
  fun deps  ->
    fun fn  ->
      let file_system_map = deps.file_system_map  in
      let all_cmd_line_files = deps.cmd_line_files  in
      let deps1 = deps.dep_graph  in
      let fn1 =
        let uu____6377 = FStar_Options.find_file fn  in
        match uu____6377 with
        | FStar_Pervasives_Native.Some fn1 -> fn1
        | uu____6385 -> fn  in
      let cache_file = cache_file_name fn1  in
      let digest_of_file1 fn2 =
        (let uu____6401 = FStar_Options.debug_any ()  in
         if uu____6401
         then FStar_Util.print2 "%s: contains digest of %s\n" cache_file fn2
         else ());
        FStar_Util.digest_of_file fn2  in
      let module_name = lowercase_module_name fn1  in
      let source_hash = digest_of_file1 fn1  in
      let interface_hash =
        let uu____6420 =
          (is_implementation fn1) &&
            (has_interface file_system_map module_name)
           in
        if uu____6420
        then
          let uu____6431 =
            let uu____6438 =
              let uu____6440 =
                let uu____6442 = interface_of file_system_map module_name  in
                FStar_Option.get uu____6442  in
              digest_of_file1 uu____6440  in
            ("interface", uu____6438)  in
          [uu____6431]
        else []  in
      let binary_deps =
        let uu____6474 =
          dependences_of file_system_map deps1 all_cmd_line_files fn1  in
        FStar_All.pipe_right uu____6474
          (FStar_List.filter
             (fun fn2  ->
                let uu____6489 =
                  (is_interface fn2) &&
                    (let uu____6492 = lowercase_module_name fn2  in
                     uu____6492 = module_name)
                   in
                Prims.op_Negation uu____6489))
         in
      let binary_deps1 =
        FStar_List.sortWith
          (fun fn11  ->
             fun fn2  ->
               let uu____6508 = lowercase_module_name fn11  in
               let uu____6510 = lowercase_module_name fn2  in
               FStar_String.compare uu____6508 uu____6510) binary_deps
         in
      let rec hash_deps out uu___127_6543 =
        match uu___127_6543 with
        | [] ->
            FStar_Pervasives_Native.Some
              (FStar_List.append (("source", source_hash) :: interface_hash)
                 out)
        | fn2::deps2 ->
            let digest =
              let fn3 = cache_file_name fn2  in
              if FStar_Util.file_exists fn3
              then
                let uu____6606 = digest_of_file1 fn3  in
                FStar_Pervasives_Native.Some uu____6606
              else
                (let uu____6611 =
                   let uu____6615 = FStar_Util.basename fn3  in
                   FStar_Options.find_file uu____6615  in
                 match uu____6611 with
                 | FStar_Pervasives_Native.None  ->
                     FStar_Pervasives_Native.None
                 | FStar_Pervasives_Native.Some fn4 ->
                     let uu____6625 = digest_of_file1 fn4  in
                     FStar_Pervasives_Native.Some uu____6625)
               in
            (match digest with
             | FStar_Pervasives_Native.None  ->
                 ((let uu____6640 = FStar_Options.debug_any ()  in
                   if uu____6640
                   then
                     let uu____6643 = cache_file_name fn2  in
                     FStar_Util.print2 "%s: missed digest of file %s\n"
                       cache_file uu____6643
                   else ());
                  FStar_Pervasives_Native.None)
             | FStar_Pervasives_Native.Some dig ->
                 let uu____6659 =
                   let uu____6668 =
                     let uu____6675 = lowercase_module_name fn2  in
                     (uu____6675, dig)  in
                   uu____6668 :: out  in
                 hash_deps uu____6659 deps2)
         in
      hash_deps [] binary_deps1
  
let (print_digest :
  (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2 Prims.list ->
    Prims.string)
  =
  fun dig  ->
    let uu____6715 =
      FStar_All.pipe_right dig
        (FStar_List.map
           (fun uu____6741  ->
              match uu____6741 with
              | (m,d) ->
                  let uu____6755 = FStar_Util.base64_encode d  in
                  FStar_Util.format2 "%s:%s" m uu____6755))
       in
    FStar_All.pipe_right uu____6715 (FStar_String.concat "\n")
  
let (print_make : deps -> unit) =
  fun deps  ->
    let file_system_map = deps.file_system_map  in
    let all_cmd_line_files = deps.cmd_line_files  in
    let deps1 = deps.dep_graph  in
    let keys = deps_keys deps1  in
    FStar_All.pipe_right keys
      (FStar_List.iter
         (fun f  ->
            let uu____6791 =
              let uu____6796 = deps_try_find deps1 f  in
              FStar_All.pipe_right uu____6796 FStar_Option.get  in
            match uu____6791 with
            | (f_deps,uu____6818) ->
                let files =
                  FStar_List.map
                    (file_of_dep file_system_map all_cmd_line_files) f_deps
                   in
                let files1 =
                  FStar_List.map
                    (fun s  -> FStar_Util.replace_chars s 32 "\\ ") files
                   in
                FStar_Util.print2 "%s: %s\n\n" f
                  (FStar_String.concat " " files1)))
  
let (print_raw : deps -> unit) =
  fun deps  ->
    let uu____6843 = deps.dep_graph  in
    match uu____6843 with
    | Deps deps1 ->
        let uu____6851 =
          let uu____6853 =
            FStar_Util.smap_fold deps1
              (fun k  ->
                 fun uu____6871  ->
                   fun out  ->
                     match uu____6871 with
                     | (dep1,uu____6885) ->
                         let uu____6886 =
                           let uu____6888 =
                             let uu____6890 =
                               FStar_List.map dep_to_string dep1  in
                             FStar_All.pipe_right uu____6890
                               (FStar_String.concat ";\n\t")
                              in
                           FStar_Util.format2 "%s -> [\n\t%s\n] " k
                             uu____6888
                            in
                         uu____6886 :: out) []
             in
          FStar_All.pipe_right uu____6853 (FStar_String.concat ";;\n")  in
        FStar_All.pipe_right uu____6851 FStar_Util.print_endline
  
let (print_full : deps -> unit) =
  fun deps  ->
    let sort_output_files orig_output_file_map =
      let order = FStar_Util.mk_ref []  in
      let remaining_output_files = FStar_Util.smap_copy orig_output_file_map
         in
      let visited_other_modules =
        FStar_Util.smap_create (Prims.parse_int "41")  in
      let should_visit lc_module_name =
        (let uu____6962 =
           FStar_Util.smap_try_find remaining_output_files lc_module_name  in
         FStar_Option.isSome uu____6962) ||
          (let uu____6969 =
             FStar_Util.smap_try_find visited_other_modules lc_module_name
              in
           FStar_Option.isNone uu____6969)
         in
      let mark_visiting lc_module_name =
        let ml_file_opt =
          FStar_Util.smap_try_find remaining_output_files lc_module_name  in
        FStar_Util.smap_remove remaining_output_files lc_module_name;
        FStar_Util.smap_add visited_other_modules lc_module_name true;
        ml_file_opt  in
      let emit_output_file_opt ml_file_opt =
        match ml_file_opt with
        | FStar_Pervasives_Native.None  -> ()
        | FStar_Pervasives_Native.Some ml_file ->
            let uu____7012 =
              let uu____7016 = FStar_ST.op_Bang order  in ml_file ::
                uu____7016
               in
            FStar_ST.op_Colon_Equals order uu____7012
         in
      let rec aux uu___128_7123 =
        match uu___128_7123 with
        | [] -> ()
        | lc_module_name::modules_to_extract ->
            let visit_file file_opt =
              match file_opt with
              | FStar_Pervasives_Native.None  -> ()
              | FStar_Pervasives_Native.Some file_name ->
                  let uu____7151 = deps_try_find deps.dep_graph file_name  in
                  (match uu____7151 with
                   | FStar_Pervasives_Native.None  ->
                       let uu____7162 =
                         FStar_Util.format2
                           "Impossible: module %s: %s not found"
                           lc_module_name file_name
                          in
                       failwith uu____7162
                   | FStar_Pervasives_Native.Some (immediate_deps,uu____7166)
                       ->
                       let immediate_deps1 =
                         FStar_List.map
                           (fun x  ->
                              FStar_String.lowercase (module_name_of_dep x))
                           immediate_deps
                          in
                       aux immediate_deps1)
               in
            ((let uu____7179 = should_visit lc_module_name  in
              if uu____7179
              then
                let ml_file_opt = mark_visiting lc_module_name  in
                ((let uu____7187 =
                    implementation_of deps.file_system_map lc_module_name  in
                  visit_file uu____7187);
                 (let uu____7192 =
                    interface_of deps.file_system_map lc_module_name  in
                  visit_file uu____7192);
                 emit_output_file_opt ml_file_opt)
              else ());
             aux modules_to_extract)
         in
      let all_extracted_modules = FStar_Util.smap_keys orig_output_file_map
         in
      aux all_extracted_modules;
      (let uu____7204 = FStar_ST.op_Bang order  in FStar_List.rev uu____7204)
       in
    let keys = deps_keys deps.dep_graph  in
    let output_file ext fst_file =
      let ml_base_name =
        let uu____7278 =
          let uu____7280 =
            let uu____7284 = FStar_Util.basename fst_file  in
            check_and_strip_suffix uu____7284  in
          FStar_Option.get uu____7280  in
        FStar_Util.replace_chars uu____7278 46 "_"  in
      FStar_Options.prepend_output_dir (Prims.strcat ml_base_name ext)  in
    let norm_path s = FStar_Util.replace_chars s 92 "/"  in
    let output_ml_file f =
      let uu____7309 = output_file ".ml" f  in norm_path uu____7309  in
    let output_krml_file f =
      let uu____7321 = output_file ".krml" f  in norm_path uu____7321  in
    let output_cmx_file f =
      let uu____7333 = output_file ".cmx" f  in norm_path uu____7333  in
    let cache_file f =
      let uu____7345 = cache_file_name f  in norm_path uu____7345  in
    let transitive_krml = FStar_Util.smap_create (Prims.parse_int "41")  in
    FStar_All.pipe_right keys
      (FStar_List.iter
         (fun file_name  ->
            let uu____7405 =
              let uu____7412 = deps_try_find deps.dep_graph file_name  in
              FStar_All.pipe_right uu____7412 FStar_Option.get  in
            match uu____7405 with
            | (f_deps,uu____7436) ->
                let iface_deps =
                  let uu____7446 = is_interface file_name  in
                  if uu____7446
                  then FStar_Pervasives_Native.None
                  else
                    (let uu____7457 =
                       let uu____7461 = lowercase_module_name file_name  in
                       interface_of deps.file_system_map uu____7461  in
                     match uu____7457 with
                     | FStar_Pervasives_Native.None  ->
                         FStar_Pervasives_Native.None
                     | FStar_Pervasives_Native.Some iface ->
                         let uu____7473 =
                           let uu____7476 =
                             let uu____7481 =
                               deps_try_find deps.dep_graph iface  in
                             FStar_Option.get uu____7481  in
                           FStar_Pervasives_Native.fst uu____7476  in
                         FStar_Pervasives_Native.Some uu____7473)
                   in
                let iface_deps1 =
                  FStar_Util.map_opt iface_deps
                    (FStar_List.filter
                       (fun iface_dep  ->
                          let uu____7506 =
                            FStar_Util.for_some (dep_subsumed_by iface_dep)
                              f_deps
                             in
                          Prims.op_Negation uu____7506))
                   in
                let norm_f = norm_path file_name  in
                let files =
                  FStar_List.map
                    (file_of_dep_aux true deps.file_system_map
                       deps.cmd_line_files) f_deps
                   in
                let files1 =
                  match iface_deps1 with
                  | FStar_Pervasives_Native.None  -> files
                  | FStar_Pervasives_Native.Some iface_deps2 ->
                      let iface_files =
                        FStar_List.map
                          (file_of_dep_aux true deps.file_system_map
                             deps.cmd_line_files) iface_deps2
                         in
                      FStar_Util.remove_dups (fun x  -> fun y  -> x = y)
                        (FStar_List.append files iface_files)
                   in
                let files2 = FStar_List.map norm_path files1  in
                let files3 =
                  FStar_List.map
                    (fun s  -> FStar_Util.replace_chars s 32 "\\ ") files2
                   in
                let files4 = FStar_String.concat "\\\n\t" files3  in
                ((let uu____7566 = cache_file file_name  in
                  FStar_Util.print3 "%s: %s \\\n\t%s\n\n" uu____7566 norm_f
                    files4);
                 (let already_there =
                    let uu____7573 =
                      let uu____7587 =
                        let uu____7589 = output_file ".krml" file_name  in
                        norm_path uu____7589  in
                      FStar_Util.smap_try_find transitive_krml uu____7587  in
                    match uu____7573 with
                    | FStar_Pervasives_Native.Some
                        (uu____7606,already_there,uu____7608) ->
                        already_there
                    | FStar_Pervasives_Native.None  -> []  in
                  (let uu____7643 =
                     let uu____7645 = output_file ".krml" file_name  in
                     norm_path uu____7645  in
                   let uu____7648 =
                     let uu____7660 =
                       let uu____7662 = output_file ".exe" file_name  in
                       norm_path uu____7662  in
                     let uu____7665 =
                       let uu____7669 =
                         let uu____7673 =
                           let uu____7677 = deps_of deps file_name  in
                           FStar_List.map
                             (fun x  ->
                                let uu____7687 = output_file ".krml" x  in
                                norm_path uu____7687) uu____7677
                            in
                         FStar_List.append already_there uu____7673  in
                       FStar_List.unique uu____7669  in
                     (uu____7660, uu____7665, false)  in
                   FStar_Util.smap_add transitive_krml uu____7643 uu____7648);
                  (let uu____7709 =
                     let uu____7718 = FStar_Options.cmi ()  in
                     if uu____7718
                     then
                       topological_dependences_of deps.file_system_map
                         deps.dep_graph deps.interfaces_with_inlining
                         [file_name] true
                     else
                       (let maybe_widen_deps f_deps1 =
                          FStar_List.map
                            (fun dep1  ->
                               file_of_dep_aux false deps.file_system_map
                                 deps.cmd_line_files dep1) f_deps1
                           in
                        let fst_files = maybe_widen_deps f_deps  in
                        let fst_files_from_iface =
                          match iface_deps1 with
                          | FStar_Pervasives_Native.None  -> []
                          | FStar_Pervasives_Native.Some iface_deps2 ->
                              maybe_widen_deps iface_deps2
                           in
                        let uu____7766 =
                          FStar_Util.remove_dups (fun x  -> fun y  -> x = y)
                            (FStar_List.append fst_files fst_files_from_iface)
                           in
                        (uu____7766, false))
                      in
                   match uu____7709 with
                   | (all_fst_files_dep,widened) ->
                       let all_checked_fst_files =
                         FStar_List.map cache_file all_fst_files_dep  in
                       let uu____7800 = is_implementation file_name  in
                       if uu____7800
                       then
                         ((let uu____7804 = (FStar_Options.cmi ()) && widened
                              in
                           if uu____7804
                           then
                             ((let uu____7808 = output_ml_file file_name  in
                               let uu____7810 = cache_file file_name  in
                               FStar_Util.print3 "%s: %s \\\n\t%s\n\n"
                                 uu____7808 uu____7810
                                 (FStar_String.concat " \\\n\t"
                                    all_checked_fst_files));
                              (let uu____7814 = output_krml_file file_name
                                  in
                               let uu____7816 = cache_file file_name  in
                               FStar_Util.print3 "%s: %s \\\n\t%s\n\n"
                                 uu____7814 uu____7816
                                 (FStar_String.concat " \\\n\t"
                                    all_checked_fst_files)))
                           else
                             ((let uu____7823 = output_ml_file file_name  in
                               let uu____7825 = cache_file file_name  in
                               FStar_Util.print2 "%s: %s \n\n" uu____7823
                                 uu____7825);
                              (let uu____7828 = output_krml_file file_name
                                  in
                               let uu____7830 = cache_file file_name  in
                               FStar_Util.print2 "%s: %s\n\n" uu____7828
                                 uu____7830)));
                          (let cmx_files =
                             let extracted_fst_files =
                               FStar_All.pipe_right all_fst_files_dep
                                 (FStar_List.filter
                                    (fun df  ->
                                       (let uu____7855 =
                                          lowercase_module_name df  in
                                        let uu____7857 =
                                          lowercase_module_name file_name  in
                                        uu____7855 <> uu____7857) &&
                                         (let uu____7861 =
                                            lowercase_module_name df  in
                                          FStar_Options.should_extract
                                            uu____7861)))
                                in
                             FStar_All.pipe_right extracted_fst_files
                               (FStar_List.map output_cmx_file)
                              in
                           let uu____7871 =
                             let uu____7873 = lowercase_module_name file_name
                                in
                             FStar_Options.should_extract uu____7873  in
                           if uu____7871
                           then
                             let uu____7876 = output_cmx_file file_name  in
                             let uu____7878 = output_ml_file file_name  in
                             FStar_Util.print3 "%s: %s \\\n\t%s\n\n"
                               uu____7876 uu____7878
                               (FStar_String.concat "\\\n\t" cmx_files)
                           else ()))
                       else
                         (let uu____7886 =
                            (let uu____7890 =
                               let uu____7892 =
                                 lowercase_module_name file_name  in
                               has_implementation deps.file_system_map
                                 uu____7892
                                in
                             Prims.op_Negation uu____7890) &&
                              (is_interface file_name)
                             in
                          if uu____7886
                          then
                            let uu____7895 =
                              (FStar_Options.cmi ()) && widened  in
                            (if uu____7895
                             then
                               let uu____7898 = output_krml_file file_name
                                  in
                               let uu____7900 = cache_file file_name  in
                               FStar_Util.print3 "%s: %s \\\n\t%s\n\n"
                                 uu____7898 uu____7900
                                 (FStar_String.concat " \\\n\t"
                                    all_checked_fst_files)
                             else
                               (let uu____7906 = output_krml_file file_name
                                   in
                                let uu____7908 = cache_file file_name  in
                                FStar_Util.print2 "%s: %s \n\n" uu____7906
                                  uu____7908))
                          else ()))))));
    (let all_fst_files =
       let uu____7917 =
         FStar_All.pipe_right keys (FStar_List.filter is_implementation)  in
       FStar_All.pipe_right uu____7917
         (FStar_Util.sort_with FStar_String.compare)
        in
     let all_ml_files =
       let ml_file_map = FStar_Util.smap_create (Prims.parse_int "41")  in
       FStar_All.pipe_right all_fst_files
         (FStar_List.iter
            (fun fst_file  ->
               let mname = lowercase_module_name fst_file  in
               let uu____7958 = FStar_Options.should_extract mname  in
               if uu____7958
               then
                 let uu____7961 = output_ml_file fst_file  in
                 FStar_Util.smap_add ml_file_map mname uu____7961
               else ()));
       sort_output_files ml_file_map  in
     let all_krml_files =
       let krml_file_map = FStar_Util.smap_create (Prims.parse_int "41")  in
       FStar_All.pipe_right keys
         (FStar_List.iter
            (fun fst_file  ->
               let mname = lowercase_module_name fst_file  in
               let uu____7988 = output_krml_file fst_file  in
               FStar_Util.smap_add krml_file_map mname uu____7988));
       sort_output_files krml_file_map  in
     let rec make_transitive f =
       let uu____8007 =
         let uu____8019 = FStar_Util.smap_try_find transitive_krml f  in
         FStar_Util.must uu____8019  in
       match uu____8007 with
       | (exe,deps1,seen) ->
           if seen
           then (exe, deps1)
           else
             (FStar_Util.smap_add transitive_krml f (exe, deps1, true);
              (let deps2 =
                 let uu____8113 =
                   let uu____8117 =
                     FStar_List.map
                       (fun dep1  ->
                          let uu____8133 = make_transitive dep1  in
                          match uu____8133 with
                          | (uu____8145,deps2) -> dep1 :: deps2) deps1
                      in
                   FStar_List.flatten uu____8117  in
                 FStar_List.unique uu____8113  in
               FStar_Util.smap_add transitive_krml f (exe, deps2, true);
               (exe, deps2)))
        in
     (let uu____8181 = FStar_Util.smap_keys transitive_krml  in
      FStar_List.iter
        (fun f  ->
           let uu____8206 = make_transitive f  in
           match uu____8206 with
           | (exe,deps1) ->
               let deps2 =
                 let uu____8227 = FStar_List.unique (f :: deps1)  in
                 FStar_String.concat " " uu____8227  in
               let wasm =
                 let uu____8236 =
                   FStar_Util.substring exe (Prims.parse_int "0")
                     ((FStar_String.length exe) - (Prims.parse_int "4"))
                    in
                 Prims.strcat uu____8236 ".wasm"  in
               (FStar_Util.print2 "%s: %s\n\n" exe deps2;
                FStar_Util.print2 "%s: %s\n\n" wasm deps2)) uu____8181);
     (let uu____8245 =
        let uu____8247 =
          FStar_All.pipe_right all_fst_files (FStar_List.map norm_path)  in
        FStar_All.pipe_right uu____8247 (FStar_String.concat " \\\n\t")  in
      FStar_Util.print1 "ALL_FST_FILES=\\\n\t%s\n\n" uu____8245);
     (let uu____8266 =
        let uu____8268 =
          FStar_All.pipe_right all_ml_files (FStar_List.map norm_path)  in
        FStar_All.pipe_right uu____8268 (FStar_String.concat " \\\n\t")  in
      FStar_Util.print1 "ALL_ML_FILES=\\\n\t%s\n\n" uu____8266);
     (let uu____8286 =
        let uu____8288 =
          FStar_All.pipe_right all_krml_files (FStar_List.map norm_path)  in
        FStar_All.pipe_right uu____8288 (FStar_String.concat " \\\n\t")  in
      FStar_Util.print1 "ALL_KRML_FILES=\\\n\t%s\n" uu____8286))
  
let (print : deps -> unit) =
  fun deps  ->
    let uu____8312 = FStar_Options.dep ()  in
    match uu____8312 with
    | FStar_Pervasives_Native.Some "make" -> print_make deps
    | FStar_Pervasives_Native.Some "full" -> print_full deps
    | FStar_Pervasives_Native.Some "graph" -> print_graph deps.dep_graph
    | FStar_Pervasives_Native.Some "raw" -> print_raw deps
    | FStar_Pervasives_Native.Some uu____8324 ->
        FStar_Errors.raise_err
          (FStar_Errors.Fatal_UnknownToolForDep, "unknown tool for --dep\n")
    | FStar_Pervasives_Native.None  -> ()
  
let (print_fsmap :
  (Prims.string FStar_Pervasives_Native.option,Prims.string
                                                 FStar_Pervasives_Native.option)
    FStar_Pervasives_Native.tuple2 FStar_Util.smap -> Prims.string)
  =
  fun fsmap  ->
    FStar_Util.smap_fold fsmap
      (fun k  ->
         fun uu____8379  ->
           fun s  ->
             match uu____8379 with
             | (v0,v1) ->
                 let uu____8408 =
                   let uu____8410 =
                     FStar_Util.format3 "%s -> (%s, %s)" k
                       (FStar_Util.dflt "_" v0) (FStar_Util.dflt "_" v1)
                      in
                   Prims.strcat "; " uu____8410  in
                 Prims.strcat s uu____8408) ""
  
let (module_has_interface : deps -> FStar_Ident.lident -> Prims.bool) =
  fun deps  ->
    fun module_name  ->
      let uu____8431 =
        let uu____8433 = FStar_Ident.string_of_lid module_name  in
        FStar_String.lowercase uu____8433  in
      has_interface deps.file_system_map uu____8431
  
let (deps_has_implementation : deps -> FStar_Ident.lident -> Prims.bool) =
  fun deps  ->
    fun module_name  ->
      let m =
        let uu____8449 = FStar_Ident.string_of_lid module_name  in
        FStar_String.lowercase uu____8449  in
      FStar_All.pipe_right deps.all_files
        (FStar_Util.for_some
           (fun f  ->
              (is_implementation f) &&
                (let uu____8460 =
                   let uu____8462 = module_name_of_file f  in
                   FStar_String.lowercase uu____8462  in
                 uu____8460 = m)))
  