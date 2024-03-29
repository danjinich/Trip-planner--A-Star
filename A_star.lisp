(DEFUN HARVESINE (COR1 COR2)
  "CALCULA LA DISTANCIA DE DOS CORDENADAS"
  (if (not (equal cor1 cor2))
    (progn (SETF COR1 (RAD COR1) COR2 (RAD COR2))
    (SETF LAT (- (FIRST COR1) (FIRST COR2)) LON (- (SECOND COR1) (SECOND COR2)) R 6371)
    (SETF A (+ (SQ (SIN (/ LAT 2))) (* (COS (FIRST COR1)) (COS (FIRST  COR2)) (SQ (SIN (/ LON 2))))))
    (* 2 R (ASIN (SQRT A))))
    0))

(DEFUN SQ (NUM)
  "CUADRADO"
  (* NUM NUM))

(DEFUN RAD (COR)
  "PASA CORDENADAS A RADIANES"
  (LIST (* PI (/ (FIRST COR) 180)) (* PI (/ (SECOND COR) 180))))


(DEFUN BUSCAR-RUTA (ORIGEN DESTINO)
  "ENCUENTRA LA MEJOR RUTA ENTRE  DOS PUNTOS"
  (SETQ ABIERTO NIL CERRADO NIL OR ORIGEN DES DESTINO LAST 0 BEST NIL)
  (SETQ COR-D (SECOND (SU-SUB DES BD)))
  (SETF SUB (SU-SUB OR BD))
  (PUSH (LIST NIL 0 (HARVESINE (SECOND SUB) COR-D) 0 OR) CERRADO)
  (EXPAND 0 0 (THIRD SUB))
  (A-ESTRELLA)
  (REGRESO))

(DEFUN EXPAND (PADRE V LST)
  "CREA LOS NODOS QUE OCURREN AL EXPANDIR UN NODO"
  (COND
    ((NULL LST))
    ((EXISTE  (CAAR LST)) (EXPAND PADRE V (CDR LST)))
    (T (PROGN
      (INCF LAST)
      (PUSH (LIST PADRE LAST (+ V (SECOND (CAR LST)) (DIST (FIRST (CAR LST)))) (+ V (SECOND (CAR LST))) (FIRST (CAR LST))) ABIERTO)
      (IF (AND (equal DES (car (LAST (CAR ABIERTO)))) (or (null best) (< (FOURTH (CAR ABIERTO)) (FOURTH BEST))))
        (SETQ BEST (CAR ABIERTO)))
      (EXPAND PADRE V (CDR LST))))))

(DEFUN EXISTE (NOM)
  "CHECA SI UN ELEMENTO YA SE USO"
  (NOT (NULL (FIND NOM (MAPCAR #'LAST CERRADO)))))

(DEFUN DIST (NOM)
  "TOMA UN NOMBRE Y REGRESA DISTANCIA AL DESTINO"
  (HARVESINE COR-D (SECOND (SU-SUB NOM BD))))


(DEFUN SU-SUB (NOM LST)
  "REGRESA LA SUB-LISTA RECIVIENDO UN NOMBRE"
  (IF (equal (CAAR LST) NOM)
    (CAR LST)
    (SU-SUB NOM (CDR LST))))

(DEFUN VERIFICAR ()
  "VERIFICA SI BEST ES EL MEJOR POSIBLE"
  (IF (NULL BEST) NIL
    (NULL (MEMBER-IF #'(LAMBDA (X) (> (FOURTH BEST) (THIRD X))) ABIERTO))))

    (DEFUN REGRESO ()
      "CREA LA LISTA DEL CAMINO"
      (SETQ R (LIST BEST))
      (REGRESO2)
      (SETQ R (MAPCAR #'LAST R)))

    (DEFUN REGRESO2 ()
      "AUXILIAR DE REGRESO"
      (cond
        ((null (caar R)))
        (t (progn (PUSH (REGRESO3 (CAAR R) CERRADO) R)
          (regreso2)))))

    (DEFUN REGRESO3 (P LST)
      "AUXILIAR DE REGRESO"
      (IF (= P (CADAR LST))
        (CAR LST)
        (REGRESO3 P (CDR LST))))

(DEFUN MENOR ()
  (SETF M (APPLY 'MIN (MAPCAR #'THIRD ABIERTO)))
  (CAR (MEMBER-IF #'(LAMBDA (X) (= M (THIRD X))) ABIERTO)))



(DEFUN A-ESTRELLA ()
  (SETF M (MENOR))
  (SETQ ABIERTO (REMOVE M ABIERTO))
  (PUSH M CERRADO)
  (EXPAND (SECOND M) (FOURTH M) (THIRD (SU-SUB (car (LAST M)) BD)))
  (IF (NOT (VERIFICAR)) (A-ESTRELLA)))


(SETQ BD '((Tijuana	(32.5027 -117.00371) ((Ensenada 106) (SanQuintin 288)))
  (Ensenada (31.86613 -116.59972) ((Tijuana 106) (Rosarito 87.8)))
  (SanQuintin	(30.4833 -115.95) ((Tijuana 288) (SantaRosalina 636)))
  (Rosarito	(30.4833 -115.3667) ((Ensenada 87.8) (SantaRosalina 901) (Loreto 1097)))
  (SantaRosalina	(27.34045 -112.26761) ((SanQuintin 636) (Rosarito 901) (Loreto 197)))
  (Loreto	(22.27248 -101.98898) ((Rosarito 1097) (SantaRosalina 197) (LaPaz 356)))
  (LaPaz	(24.1164329 -110.337743) ((Loreto 356) (SanLucas 158)))
  (SanLucas	(22.8962225 -109.968017) ((LaPaz 158)))))

;(trace a-ESTRELLA menor Regreso REGRESO2 REGRESO3 VERIFICAR su-sub dist EXISTE EXPAND)

(Buscar-ruta 'Tijuana 'Loreto)
