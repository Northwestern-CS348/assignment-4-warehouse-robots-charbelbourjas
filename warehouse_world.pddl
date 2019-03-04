(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?start - location ?end - location)
      :precondition (and (at ?r ?start)(no-robot ?end)(connected ?start ?end))
      :effect (and (at ?r ?end) (not (at ?r ?start)) (no-robot ?start) (not (no-robot ?end)))
    )
    
   (:action robotMoveWithPallette
      :parameters (?start - location ?end - location ?r - robot ?p - pallette)
      :precondition (and (at ?p ?start)(at ?r ?start)(free ?r)(no-robot ?end)(no-pallette ?end)(connected ?start ?end))
      :effect (and (not(at ?r ?start))(at ?r ?end)(not(at ?p ?start))(at ?p ?end)(not(no-robot ?end))(no-robot ?start)(not(no-pallette ?end))(no-pallette ?start)(has ?r ?p))
   )
    
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (orders ?o ?si) (packing-location ?l) (contains ?p ?si) (packing-at ?s ?l) (at ?p ?l) (not (includes ?s ?si)))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )
    
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (packing-location ?l) (packing-at ?s ?l) (ships ?s ?o) (not (available ?l)) (not (complete ?s)))
      :effect (and (available ?l) (complete ?s))
   )

)
