
open Prims
let pruneNones = (fun l -> (FStar_List.fold_right (fun x ll -> (match (x) with
| Some (xs) -> begin
(xs)::ll
end
| None -> begin
ll
end)) l []))

let mlconst_of_const = (fun sctt -> (match (sctt) with
| FStar_Absyn_Syntax.Const_unit -> begin
FStar_Extraction_ML_Syntax.MLC_Unit
end
| FStar_Absyn_Syntax.Const_char (c) -> begin
FStar_Extraction_ML_Syntax.MLC_Char (c)
end
| FStar_Absyn_Syntax.Const_uint8 (c) -> begin
FStar_Extraction_ML_Syntax.MLC_Byte (c)
end
| FStar_Absyn_Syntax.Const_int (c) -> begin
FStar_Extraction_ML_Syntax.MLC_Int (c)
end
| FStar_Absyn_Syntax.Const_int32 (i) -> begin
FStar_Extraction_ML_Syntax.MLC_Int32 (i)
end
| FStar_Absyn_Syntax.Const_int64 (i) -> begin
FStar_Extraction_ML_Syntax.MLC_Int64 (i)
end
| FStar_Absyn_Syntax.Const_bool (b) -> begin
FStar_Extraction_ML_Syntax.MLC_Bool (b)
end
| FStar_Absyn_Syntax.Const_float (d) -> begin
FStar_Extraction_ML_Syntax.MLC_Float (d)
end
| FStar_Absyn_Syntax.Const_bytearray (bytes, _58_31) -> begin
FStar_Extraction_ML_Syntax.MLC_Bytes (bytes)
end
| FStar_Absyn_Syntax.Const_string (bytes, _58_36) -> begin
FStar_Extraction_ML_Syntax.MLC_String ((FStar_Util.string_of_unicode bytes))
end))

let mlconst_of_const' = (fun p c -> (FStar_All.try_with (fun _58_42 -> (match (()) with
| () -> begin
(mlconst_of_const c)
end)) (fun _58_41 -> (match (_58_41) with
| _58_45 -> begin
(let _124_14 = (let _124_13 = (FStar_Range.string_of_range p)
in (let _124_12 = (FStar_Absyn_Print.const_to_string c)
in (FStar_Util.format2 "(%s) Failed to translate constant %s " _124_13 _124_12)))
in (FStar_All.failwith _124_14))
end))))

let rec subst_aux = (fun subst t -> (match (t) with
| FStar_Extraction_ML_Syntax.MLTY_Var (x) -> begin
(match ((FStar_Util.find_opt (fun _58_55 -> (match (_58_55) with
| (y, _58_54) -> begin
(y = x)
end)) subst)) with
| Some (ts) -> begin
(Prims.snd ts)
end
| None -> begin
t
end)
end
| FStar_Extraction_ML_Syntax.MLTY_Fun (t1, f, t2) -> begin
(let _124_22 = (let _124_21 = (subst_aux subst t1)
in (let _124_20 = (subst_aux subst t2)
in (_124_21, f, _124_20)))
in FStar_Extraction_ML_Syntax.MLTY_Fun (_124_22))
end
| FStar_Extraction_ML_Syntax.MLTY_Named (args, path) -> begin
(let _124_24 = (let _124_23 = (FStar_List.map (subst_aux subst) args)
in (_124_23, path))
in FStar_Extraction_ML_Syntax.MLTY_Named (_124_24))
end
| FStar_Extraction_ML_Syntax.MLTY_Tuple (ts) -> begin
(let _124_25 = (FStar_List.map (subst_aux subst) ts)
in FStar_Extraction_ML_Syntax.MLTY_Tuple (_124_25))
end
| FStar_Extraction_ML_Syntax.MLTY_Top -> begin
FStar_Extraction_ML_Syntax.MLTY_Top
end))

let subst = (fun _58_73 args -> (match (_58_73) with
| (formals, t) -> begin
(match (((FStar_List.length formals) <> (FStar_List.length args))) with
| true -> begin
(FStar_All.failwith "Substitution must be fully applied")
end
| false -> begin
(let _124_30 = (FStar_List.zip formals args)
in (subst_aux _124_30 t))
end)
end))

let delta_unfold = (fun g _58_1 -> (match (_58_1) with
| FStar_Extraction_ML_Syntax.MLTY_Named (args, n) -> begin
(match ((FStar_Extraction_ML_Env.lookup_ty_const g n)) with
| Some (ts) -> begin
(let _124_35 = (subst ts args)
in Some (_124_35))
end
| _58_84 -> begin
None
end)
end
| _58_86 -> begin
None
end))

let eff_leq = (fun f f' -> (match ((f, f')) with
| (FStar_Extraction_ML_Syntax.E_PURE, _58_91) -> begin
true
end
| (FStar_Extraction_ML_Syntax.E_GHOST, FStar_Extraction_ML_Syntax.E_GHOST) -> begin
true
end
| (FStar_Extraction_ML_Syntax.E_IMPURE, FStar_Extraction_ML_Syntax.E_IMPURE) -> begin
true
end
| _58_100 -> begin
false
end))

let eff_to_string = (fun _58_2 -> (match (_58_2) with
| FStar_Extraction_ML_Syntax.E_PURE -> begin
"Pure"
end
| FStar_Extraction_ML_Syntax.E_GHOST -> begin
"Ghost"
end
| FStar_Extraction_ML_Syntax.E_IMPURE -> begin
"Impure"
end))

let join = (fun f f' -> (match ((f, f')) with
| ((FStar_Extraction_ML_Syntax.E_IMPURE, FStar_Extraction_ML_Syntax.E_PURE)) | ((FStar_Extraction_ML_Syntax.E_PURE, FStar_Extraction_ML_Syntax.E_IMPURE)) | ((FStar_Extraction_ML_Syntax.E_IMPURE, FStar_Extraction_ML_Syntax.E_IMPURE)) -> begin
FStar_Extraction_ML_Syntax.E_IMPURE
end
| (FStar_Extraction_ML_Syntax.E_GHOST, FStar_Extraction_ML_Syntax.E_GHOST) -> begin
FStar_Extraction_ML_Syntax.E_GHOST
end
| (FStar_Extraction_ML_Syntax.E_PURE, FStar_Extraction_ML_Syntax.E_GHOST) -> begin
FStar_Extraction_ML_Syntax.E_GHOST
end
| (FStar_Extraction_ML_Syntax.E_GHOST, FStar_Extraction_ML_Syntax.E_PURE) -> begin
FStar_Extraction_ML_Syntax.E_GHOST
end
| (FStar_Extraction_ML_Syntax.E_PURE, FStar_Extraction_ML_Syntax.E_PURE) -> begin
FStar_Extraction_ML_Syntax.E_PURE
end
| _58_129 -> begin
(let _124_46 = (FStar_Util.format2 "Impossible: Inconsistent effects %s and %s" (eff_to_string f) (eff_to_string f'))
in (FStar_All.failwith _124_46))
end))

let join_l = (fun fs -> (FStar_List.fold_left join FStar_Extraction_ML_Syntax.E_PURE fs))

let mk_ty_fun = (fun _66_95 -> (FStar_List.fold_right (fun _58_134 t -> (match (_58_134) with
| (_58_132, t0) -> begin
FStar_Extraction_ML_Syntax.MLTY_Fun ((t0, FStar_Extraction_ML_Syntax.E_PURE, t))
end))))

let rec type_leq_c = (fun g e t t' -> (match ((t, t')) with
| (FStar_Extraction_ML_Syntax.MLTY_Var (x), FStar_Extraction_ML_Syntax.MLTY_Var (y)) -> begin
(match (((Prims.fst x) = (Prims.fst y))) with
| true -> begin
(true, e)
end
| false -> begin
(false, None)
end)
end
| (FStar_Extraction_ML_Syntax.MLTY_Fun (t1, f, t2), FStar_Extraction_ML_Syntax.MLTY_Fun (t1', f', t2')) -> begin
(let mk_fun = (fun xs body -> (match (xs) with
| [] -> begin
body
end
| _58_161 -> begin
(let e = (match (body.FStar_Extraction_ML_Syntax.expr) with
| FStar_Extraction_ML_Syntax.MLE_Fun (ys, body) -> begin
FStar_Extraction_ML_Syntax.MLE_Fun (((FStar_List.append xs ys), body))
end
| _58_167 -> begin
FStar_Extraction_ML_Syntax.MLE_Fun ((xs, body))
end)
in (let _124_68 = ((mk_ty_fun ()) xs body.FStar_Extraction_ML_Syntax.ty)
in (FStar_Extraction_ML_Syntax.with_ty _124_68 e)))
end))
in (match (e) with
| Some ({FStar_Extraction_ML_Syntax.expr = FStar_Extraction_ML_Syntax.MLE_Fun (x::xs, body); FStar_Extraction_ML_Syntax.ty = _58_170}) -> begin
(match (((type_leq g t1' t1) && (eff_leq f f'))) with
| true -> begin
(match (((f = FStar_Extraction_ML_Syntax.E_PURE) && (f' = FStar_Extraction_ML_Syntax.E_GHOST))) with
| true -> begin
(match ((type_leq g t2 t2')) with
| true -> begin
(let body = (match ((type_leq g t2 FStar_Extraction_ML_Syntax.ml_unit_ty)) with
| true -> begin
FStar_Extraction_ML_Syntax.ml_unit
end
| false -> begin
(FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty t2') (FStar_Extraction_ML_Syntax.MLE_Coerce ((FStar_Extraction_ML_Syntax.ml_unit, FStar_Extraction_ML_Syntax.ml_unit_ty, t2'))))
end)
in (let _124_72 = (let _124_71 = (let _124_70 = (let _124_69 = ((mk_ty_fun ()) ((x)::[]) body.FStar_Extraction_ML_Syntax.ty)
in (FStar_Extraction_ML_Syntax.with_ty _124_69))
in (FStar_All.pipe_left _124_70 (FStar_Extraction_ML_Syntax.MLE_Fun (((x)::[], body)))))
in Some (_124_71))
in (true, _124_72)))
end
| false -> begin
(false, None)
end)
end
| false -> begin
(let _58_182 = (let _124_75 = (let _124_74 = (mk_fun xs body)
in (FStar_All.pipe_left (fun _124_73 -> Some (_124_73)) _124_74))
in (type_leq_c g _124_75 t2 t2'))
in (match (_58_182) with
| (ok, body) -> begin
(let res = (match (body) with
| Some (body) -> begin
(let _124_76 = (mk_fun ((x)::[]) body)
in Some (_124_76))
end
| _58_186 -> begin
None
end)
in (ok, res))
end))
end)
end
| false -> begin
(false, None)
end)
end
| _58_189 -> begin
(match ((((type_leq g t1' t1) && (eff_leq f f')) && (type_leq g t2 t2'))) with
| true -> begin
(true, e)
end
| false -> begin
(false, None)
end)
end))
end
| (FStar_Extraction_ML_Syntax.MLTY_Named (args, path), FStar_Extraction_ML_Syntax.MLTY_Named (args', path')) -> begin
(match ((path = path')) with
| true -> begin
(match ((FStar_List.forall2 (type_leq g) args args')) with
| true -> begin
(true, e)
end
| false -> begin
(false, None)
end)
end
| false -> begin
(match ((delta_unfold g t)) with
| Some (t) -> begin
(type_leq_c g e t t')
end
| None -> begin
(match ((delta_unfold g t')) with
| None -> begin
(false, None)
end
| Some (t') -> begin
(type_leq_c g e t t')
end)
end)
end)
end
| (FStar_Extraction_ML_Syntax.MLTY_Tuple (ts), FStar_Extraction_ML_Syntax.MLTY_Tuple (ts')) -> begin
(match ((FStar_List.forall2 (type_leq g) ts ts')) with
| true -> begin
(true, e)
end
| false -> begin
(false, None)
end)
end
| (FStar_Extraction_ML_Syntax.MLTY_Top, FStar_Extraction_ML_Syntax.MLTY_Top) -> begin
(true, e)
end
| (FStar_Extraction_ML_Syntax.MLTY_Named (_58_214), _58_217) -> begin
(match ((delta_unfold g t)) with
| Some (t) -> begin
(type_leq_c g e t t')
end
| _58_222 -> begin
(false, None)
end)
end
| (_58_224, FStar_Extraction_ML_Syntax.MLTY_Named (_58_226)) -> begin
(match ((delta_unfold g t')) with
| Some (t') -> begin
(type_leq_c g e t t')
end
| _58_232 -> begin
(false, None)
end)
end
| _58_234 -> begin
(false, None)
end))
and type_leq = (fun g t1 t2 -> (let _124_80 = (type_leq_c g None t1 t2)
in (FStar_All.pipe_right _124_80 Prims.fst)))

let unit_binder = (let x = (FStar_Absyn_Util.gen_bvar FStar_Tc_Recheck.t_unit)
in (FStar_Absyn_Syntax.v_binder x))

let is_type_abstraction = (fun _58_3 -> (match (_58_3) with
| (FStar_Util.Inl (_58_243), _58_246)::_58_241 -> begin
true
end
| _58_250 -> begin
false
end))

let mkTypFun = (fun bs c original -> (FStar_Absyn_Syntax.mk_Typ_fun (bs, c) None original.FStar_Absyn_Syntax.pos))

let mkTypApp = (fun typ arrgs original -> (FStar_Absyn_Syntax.mk_Typ_app (typ, arrgs) None original.FStar_Absyn_Syntax.pos))

let tbinder_prefix = (fun t -> (match ((let _124_96 = (FStar_Absyn_Util.compress_typ t)
in _124_96.FStar_Absyn_Syntax.n)) with
| FStar_Absyn_Syntax.Typ_fun (bs, c) -> begin
(match ((FStar_Util.prefix_until (fun _58_4 -> (match (_58_4) with
| (FStar_Util.Inr (_58_264), _58_267) -> begin
true
end
| _58_270 -> begin
false
end)) bs)) with
| None -> begin
(bs, t)
end
| Some (bs, b, rest) -> begin
(let _124_98 = (mkTypFun ((b)::rest) c t)
in (bs, _124_98))
end)
end
| _58_278 -> begin
([], t)
end))

let is_xtuple = (fun _58_281 -> (match (_58_281) with
| (ns, n) -> begin
(match ((ns = ("Prims")::[])) with
| true -> begin
(match (n) with
| "MkTuple2" -> begin
Some (2)
end
| "MkTuple3" -> begin
Some (3)
end
| "MkTuple4" -> begin
Some (4)
end
| "MkTuple5" -> begin
Some (5)
end
| "MkTuple6" -> begin
Some (6)
end
| "MkTuple7" -> begin
Some (7)
end
| _58_289 -> begin
None
end)
end
| false -> begin
None
end)
end))

let resugar_exp = (fun e -> (match (e.FStar_Extraction_ML_Syntax.expr) with
| FStar_Extraction_ML_Syntax.MLE_CTor (mlp, args) -> begin
(match ((is_xtuple mlp)) with
| Some (n) -> begin
(FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty e.FStar_Extraction_ML_Syntax.ty) (FStar_Extraction_ML_Syntax.MLE_Tuple (args)))
end
| _58_298 -> begin
e
end)
end
| _58_300 -> begin
e
end))

let record_field_path = (fun _58_5 -> (match (_58_5) with
| f::_58_303 -> begin
(let _58_309 = (FStar_Util.prefix f.FStar_Absyn_Syntax.ns)
in (match (_58_309) with
| (ns, _58_308) -> begin
(FStar_All.pipe_right ns (FStar_List.map (fun id -> id.FStar_Absyn_Syntax.idText)))
end))
end
| _58_312 -> begin
(FStar_All.failwith "impos")
end))

let record_fields = (fun fs vs -> (FStar_List.map2 (fun f e -> (f.FStar_Absyn_Syntax.ident.FStar_Absyn_Syntax.idText, e)) fs vs))

let resugar_pat = (fun q p -> (match (p) with
| FStar_Extraction_ML_Syntax.MLP_CTor (d, pats) -> begin
(match ((is_xtuple d)) with
| Some (n) -> begin
FStar_Extraction_ML_Syntax.MLP_Tuple (pats)
end
| _58_326 -> begin
(match (q) with
| Some (FStar_Absyn_Syntax.Record_ctor (_58_328, fns)) -> begin
(let p = (record_field_path fns)
in (let fs = (record_fields fns pats)
in FStar_Extraction_ML_Syntax.MLP_Record ((p, fs))))
end
| _58_336 -> begin
p
end)
end)
end
| _58_338 -> begin
p
end))

let is_xtuple_ty = (fun _58_341 -> (match (_58_341) with
| (ns, n) -> begin
(match ((ns = ("Prims")::[])) with
| true -> begin
(match (n) with
| "Tuple2" -> begin
Some (2)
end
| "Tuple3" -> begin
Some (3)
end
| "Tuple4" -> begin
Some (4)
end
| "Tuple5" -> begin
Some (5)
end
| "Tuple6" -> begin
Some (6)
end
| "Tuple7" -> begin
Some (7)
end
| _58_349 -> begin
None
end)
end
| false -> begin
None
end)
end))

let resugar_mlty = (fun t -> (match (t) with
| FStar_Extraction_ML_Syntax.MLTY_Named (args, mlp) -> begin
(match ((is_xtuple_ty mlp)) with
| Some (n) -> begin
FStar_Extraction_ML_Syntax.MLTY_Tuple (args)
end
| _58_358 -> begin
t
end)
end
| _58_360 -> begin
t
end))

let codegen_fsharp = (fun _58_361 -> (match (()) with
| () -> begin
((let _124_120 = (FStar_ST.read FStar_Options.codegen)
in (FStar_Option.get _124_120)) = "FSharp")
end))

let flatten_ns = (fun ns -> (match ((codegen_fsharp ())) with
| true -> begin
(FStar_String.concat "." ns)
end
| false -> begin
(FStar_String.concat "_" ns)
end))

let flatten_mlpath = (fun _58_365 -> (match (_58_365) with
| (ns, n) -> begin
(match ((codegen_fsharp ())) with
| true -> begin
(FStar_String.concat "." (FStar_List.append ns ((n)::[])))
end
| false -> begin
(FStar_String.concat "_" (FStar_List.append ns ((n)::[])))
end)
end))

let mlpath_of_lid = (fun l -> (let _124_128 = (FStar_All.pipe_right l.FStar_Absyn_Syntax.ns (FStar_List.map (fun i -> i.FStar_Absyn_Syntax.idText)))
in (_124_128, l.FStar_Absyn_Syntax.ident.FStar_Absyn_Syntax.idText)))

let rec erasableType = (fun g t -> (match ((FStar_Extraction_ML_Env.erasableTypeNoDelta t)) with
| true -> begin
true
end
| false -> begin
(match ((delta_unfold g t)) with
| Some (t) -> begin
(erasableType g t)
end
| None -> begin
false
end)
end))

let rec eraseTypeDeep = (fun g t -> (match (t) with
| FStar_Extraction_ML_Syntax.MLTY_Fun (tyd, etag, tycd) -> begin
(match ((etag = FStar_Extraction_ML_Syntax.E_PURE)) with
| true -> begin
(let _124_139 = (let _124_138 = (eraseTypeDeep g tyd)
in (let _124_137 = (eraseTypeDeep g tycd)
in (_124_138, etag, _124_137)))
in FStar_Extraction_ML_Syntax.MLTY_Fun (_124_139))
end
| false -> begin
t
end)
end
| FStar_Extraction_ML_Syntax.MLTY_Named (lty, mlp) -> begin
(match ((erasableType g t)) with
| true -> begin
FStar_Extraction_ML_Env.erasedContent
end
| false -> begin
(let _124_141 = (let _124_140 = (FStar_List.map (eraseTypeDeep g) lty)
in (_124_140, mlp))
in FStar_Extraction_ML_Syntax.MLTY_Named (_124_141))
end)
end
| FStar_Extraction_ML_Syntax.MLTY_Tuple (lty) -> begin
(let _124_142 = (FStar_List.map (eraseTypeDeep g) lty)
in FStar_Extraction_ML_Syntax.MLTY_Tuple (_124_142))
end
| _58_387 -> begin
t
end))

let prims_op_equality = (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) (FStar_Extraction_ML_Syntax.MLE_Name ((("Prims")::[], "op_Equality"))))

let prims_op_amp_amp = (let _124_144 = (let _124_143 = ((mk_ty_fun ()) (((("x", 0), FStar_Extraction_ML_Syntax.ml_bool_ty))::((("y", 0), FStar_Extraction_ML_Syntax.ml_bool_ty))::[]) FStar_Extraction_ML_Syntax.ml_bool_ty)
in (FStar_Extraction_ML_Syntax.with_ty _124_143))
in (FStar_All.pipe_left _124_144 (FStar_Extraction_ML_Syntax.MLE_Name ((("Prims")::[], "op_AmpAmp")))))

let conjoin = (fun e1 e2 -> (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.ml_bool_ty) (FStar_Extraction_ML_Syntax.MLE_App ((prims_op_amp_amp, (e1)::(e2)::[])))))

let conjoin_opt = (fun e1 e2 -> (match ((e1, e2)) with
| (None, None) -> begin
None
end
| ((Some (x), None)) | ((None, Some (x))) -> begin
Some (x)
end
| (Some (x), Some (y)) -> begin
(let _124_153 = (conjoin x y)
in Some (_124_153))
end))




