;  Another neon-like logo
;   Written by Laurence Colombet
;   Released under GPL v.2

(define (script-fu-text-neon-logo text
				  size
				  font
				  grow
				  halogrow
				  neon-color
				  dazzle-color
				  halo-color
				  bg-color)
  (let* (
	 (old-fg (car (gimp-context-get-foreground)))
	 (old-bg (car (gimp-context-get-background)))
	 (img (car (gimp-image-new 256 256 RGB)))
	 (border (/ size 4))
     (neon-layer (car (gimp-text-fontname img -1 0 0 text border TRUE size PIXELS font)))	      
     (width (car (gimp-drawable-width neon-layer)))
     (height (car (gimp-drawable-height neon-layer)))
     (bg-layer (car (gimp-layer-new img width height RGBA-IMAGE "Background" 100 NORMAL-MODE)))
	 (outline-layer 0)
	 (halo-layer 0)
	 )

    ; Sets the layers.
    (gimp-context-set-foreground halo-color)
    (gimp-image-resize img width height 0 0)

    ; Enlarge or shrink the font before copying the layer.
    (if (> grow 0)
	(while (> grow 0)
	       (plug-in-vpropagate 1 img neon-layer 6 15 1 15 0 255)
	       (set! grow (- grow 1))
	       )
	)
    (if (< grow 0)
	(while (< grow 0)
	       (plug-in-vpropagate 1 img neon-layer 7 15 1 15 0 255)
	       (set! grow (+ grow 1))
	       )
	)

    (gimp-selection-layer-alpha neon-layer)
    (gimp-edit-fill neon-layer FOREGROUND-FILL)
    (gimp-selection-none img)

    (set! outline-layer (car (gimp-layer-copy neon-layer TRUE)))
    (set! halo-layer (car (gimp-layer-copy neon-layer TRUE)))

    (gimp-drawable-set-name neon-layer text)
    (gimp-drawable-set-name outline-layer "Outline")
    (gimp-drawable-set-name halo-layer "Glow")

    (gimp-image-add-layer img outline-layer 1)
    (gimp-image-add-layer img halo-layer 2)
    (gimp-image-add-layer img bg-layer 3)

    ; Background.
    (gimp-context-set-background bg-color)
    (gimp-edit-fill bg-layer BACKGROUND-FILL)

    ; Halo.
    (while (> halogrow 0)
	   (plug-in-vpropagate 1 img halo-layer 6 15 1 15 0 255)
	   (set! halogrow (- halogrow 1))
	   )
    (plug-in-gauss-iir2 1 img halo-layer 50 50)

    ; Neon tubes.
    (gimp-context-set-foreground dazzle-color)
    (gimp-context-set-background neon-color)
    (gimp-selection-layer-alpha neon-layer)
    (gimp-edit-blend neon-layer 0 NORMAL-MODE 7 100 0 0 FALSE FALSE 1 0 TRUE 0 0 1 1)
    (gimp-selection-none img)

    ; Outline.
    ; XXX: Why doesn't the Sobel edge detect recognise the text edges??
    (gimp-context-set-foreground halo-color)
    (gimp-context-set-background bg-color)
    (gimp-selection-layer-alpha outline-layer)
    (gimp-edit-fill outline-layer BACKGROUND-FILL)
    (gimp-selection-none img)
    (plug-in-sobel 1 img outline-layer TRUE TRUE TRUE)
    ;(gimp-layer-set-mode outline-layer SCREEN-MODE)
    (gimp-selection-layer-alpha outline-layer)
    (gimp-edit-fill outline-layer FOREGROUND-FILL)
    (gimp-selection-none img)

    (gimp-context-set-background old-bg)
    (gimp-context-set-foreground old-fg)

    (gimp-display-new img)
    )
  )

;(script-fu-register "script-fu-text-neon-logo"
;		    _"<Toolbox>/Xtns/Script-Fu/Logos/Neon Like Text..."
;		    "Very customisable neon-like logo"
;		    "Laurence Colombet aka Laura Dove"
;		    "Laurence Colombet aka Laura Dove"
;		    "2003"		    ""
;		    SF-STRING _"Text" "-*-eras-medium-*-*-*-24-*-*-*-*-*-*-*"
;		    SF-ADJUSTMENT _"Font size (pixels)"     '(160 2 1000 1 10 0 1)
;		    SF-FONT   _"Font" "Blippo"
;		    SF-ADJUSTMENT _"Text Enlargment Factor" '(0 -10 10 1 10 0 1)
;		    SF-ADJUSTMENT _"Halo Enlargment Factor" '(8 0 16 1 10 0 1)	   
;		    SF-COLOR  _"Dazzle Neon Color"         '(0 255 255)
;		    SF-COLOR  _"Dazzle Neon Color"  '(239 255 255)
;		    SF-COLOR  _"Halo color"         '(0 0 255)
;		    SF-COLOR  _"Background color"   '(0 0 0)
;		    )

(script-fu-register "script-fu-text-neon-logo"
		    _"Neon Like Text..."
		    "                           "
		    "Laurence Colombet aka Laura Dove"
		    "Laurence Colombet aka Laura Dove"
		    "2003"		    ""
		    SF-STRING     _"Text"               "NEON"
		    SF-ADJUSTMENT _"Font size (pixels)" '(160 2 1000 1 10 0 1)
		    SF-FONT       _"Font"               "Blippo"
		    SF-ADJUSTMENT _"               "         '(0 -10 10 1 10 0 1)
		    SF-ADJUSTMENT _"               "         '(8 0 16 1 10 0 1)	   
		    SF-COLOR      _"                  "       '(0 255 255)
		    SF-COLOR      _"                  "       '(239 255 255)
		    SF-COLOR      _"         "             '(0 0 255)
		    SF-COLOR      _"         "             '(0 0 0)
		    )

(script-fu-menu-register "script-fu-text-neon-logo"
		    _"<Toolbox>/Xtns/Extra Logos")