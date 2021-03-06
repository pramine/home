; convert image luminance to transparent for GIMP 2.0
;   <Image>/Layer/Convert luminance to transparent...
;   v1.01 (2004/12/29 : bug fix for GIMP 2.2)

; auther:temp_h<temp_h@pandora.nu>
; coment:Japanese(UTF-8)
;---------------------------------------------------------------------
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;---------------------------------------------------------------------

(define (script-fu-luminance2transparent
    Image
    Drawable
    Col
    DelLayer
    PreserveTrans
  )

  (let*(
      (CurrentFGColor (car (gimp-context-get-foreground)));                            
      (CurrentBGColor (car (gimp-context-get-background)))
      (Width  (car (gimp-image-width Image)))
      (Height (car (gimp-image-height Image)))
      (WhiteBack (car (gimp-layer-new Image Width Height 1 "converted layer" 100 0)))
      (Active-layer 0)
      (NewDrawable 0)
      (Mask 0)
    )
    (gimp-image-undo-group-start Image) ;                   
    ;                 drawable                                                                            
    (if (car (gimp-drawable-is-layer-mask Drawable))
      (set! Active-layer (car (gimp-image-get-active-layer Image)))
    )
    ;                               
    (gimp-selection-all Image)

    ;                                                       
    (set! NewDrawable (car (gimp-layer-copy Active-layer TRUE)))
    (gimp-image-add-layer Image NewDrawable -1)
    ;                                        
    (gimp-drawable-set-visible Active-layer FALSE)
        
    ;                                                    
    (if (not (= (car (gimp-layer-get-mask NewDrawable)) -1)) (gimp-layer-remove-mask NewDrawable 0))
    ;                                                                                                                                     
    (gimp-image-add-layer Image WhiteBack -1)
    (gimp-context-set-background '(255 255 255))
    (gimp-drawable-fill WhiteBack 1)
    (gimp-image-raise-layer Image NewDrawable)
    (set! NewDrawable (car (gimp-image-merge-down Image NewDrawable 2)))

    ;                                           
    (set! Mask (car (gimp-layer-create-mask NewDrawable 5)))
    ;                            
    (gimp-context-set-foreground Col)
    (gimp-drawable-fill NewDrawable 0)
    ;                   
    (gimp-layer-add-mask NewDrawable Mask)
    (gimp-invert Mask) ;                           
    (gimp-layer-remove-mask NewDrawable 0)

    ;             
    (gimp-selection-clear Image) ;            
    ;                                           
    (if (eqv? DelLayer TRUE) (gimp-image-remove-layer Image Active-layer))
    ;                                     
    (if (eqv? PreserveTrans TRUE)
      (gimp-layer-set-preserve-trans NewDrawable TRUE)
      (gimp-layer-set-preserve-trans NewDrawable FALSE)
    )
    ;                                  
    (gimp-context-set-foreground CurrentFGColor)
    (gimp-context-set-background CurrentBGColor)
    ;                   
    (gimp-image-undo-group-end Image)
    (gimp-displays-flush) ;      
  )
)

;            
(script-fu-register
  "script-fu-luminance2transparent"
  "Convert luminance to transparent..."
  "convert image luminance to transparent.\n                                                         "
  "temp_h"
  "Copyright 2004, temp_h"
  "Dec, 2004"
  "RGB*, GRAY*"
  SF-IMAGE      "Image" 0
  SF-DRAWABLE   "Drawable" 0
  SF-COLOR      "Fill color                        " '(0 0 0)
  SF-TOGGLE     "Delete original layer                              " FALSE
  SF-TOGGLE     "Preserve transperancy                        " TRUE
)

(script-fu-menu-register
  "script-fu-luminance2transparent"
  "<Image>/Layer"
)