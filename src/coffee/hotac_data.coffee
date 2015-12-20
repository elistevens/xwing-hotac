exportObj = exports ? this

#EventEmitter2 = require('eventemitter2').EventEmitter2;

clone = (obj) ->
    if not obj? or typeof obj isnt 'object' #or obj.isGlobalState
        return obj

    if obj instanceof Date
        return new Date(obj.getTime())

    if obj instanceof RegExp
        flags = ''
        flags += 'g' if obj.global?
        flags += 'i' if obj.ignoreCase?
        flags += 'm' if obj.multiline?
        flags += 'y' if obj.sticky?
        return new RegExp(obj.source, flags)

    newInstance = new obj.constructor()

    for key of obj
        newInstance[key] = clone obj[key]

    return newInstance

class EnemyAi
    constructor: () ->
        @movement_dict = {}
        @movement_dict.ahead = clone @genericMovement_dict.ahead
        @movement_dict.behind = clone @genericMovement_dict.behind

        for dir in ['ahead', 'flank', 'behind']
            for bearing in ['right', 'left']
                @movement_dict["#{dir}#{bearing}"] = {}
                for dist in ['far', 'near']
                    if @genericMovement_dict["#{dir}x"][dist].length != 6
                        console.log("#{@name} #{dir} #{dist} length #{@genericMovement_dict["#{dir}x"][dist].length}")

                    @movement_dict["#{dir}#{bearing}"][dist] = []
                    for move_tup, index in @genericMovement_dict["#{dir}x"][dist]
                        move_tup = clone move_tup
                        if move_tup[1] == 'x'
                            move_tup[1] = bearing
                        if move_tup[1] == 'y'
                            if bearing == 'left'
                                move_tup[1] = 'right'
                            else
                                move_tup[1] = 'left'

                        @movement_dict["#{dir}#{bearing}"][dist][index] = move_tup

    initDom: (@ship_str) ->
        t = @
        @elem_id = "ai-#{@ship_str}"
        $("##{@elem_id} .panel-title").text("#{@name}")
        $("##{@elem_id} .displayship i").removeClass()\
                .addClass("xwing-miniatures-ship xwing-miniatures-ship-#{@id}")
        $("\#ai-panel \#ai-toggle-#{@ship_str} i").removeClass()\
                .addClass("xwing-miniatures-ship xwing-miniatures-ship-#{@id}")
        $("\#ai-panel \#ai-toggle-#{@ship_str}").on(
                'click',
                null,
                null,
                (event) -> t.onClick_toggle(event))

        for dir in ['ahead', 'flank', 'behind']
            for bearing in ['', 'right', 'left']
                sector = "#{dir}#{bearing}"
                if sector != 'flank'
                    for distance in ['far', 'near']
                        $("##{@elem_id} .#{sector}.#{distance}").on(
                                'click',
                                null,
                                {'sector': sector, 'distance': distance},
                                (event) -> t.onClick_move(event))

                        $("##{@elem_id} .displayship").on(
                                'click',
                                null,
                                null,
                                (event) -> t.onClick_ship(event))

        if @defaultshow
            @onClick_toggle()


    onClick_move: (event) ->
        move_tup = @movement_dict[event.data.sector][event.data.distance][Math.floor(Math.random() * 6)]
        move_str = "#{move_tup[0]}#{move_tup[1] or ''}#{move_tup[2]}"
        color = @color_dict[move_str] or 'white'

        console.log("#{event.data.sector} #{event.data.distance}: #{move_str}")

        $("##{@elem_id} .display i").removeClass()
        $("##{@elem_id} .display span").removeClass().text('')
        $("##{@elem_id} .#{event.data.sector}.#{event.data.distance}.display i")\
                .addClass("xwing-miniatures-font xwing-miniatures-font-#{move_tup[0]}#{move_tup[1] or ''} #{color}")
        $("##{@elem_id} .#{event.data.sector}.#{event.data.distance}.display span").addClass(color).text(move_tup[2])

    onClick_ship: (event) ->
        $("##{@elem_id} .display i").removeClass()
        $("##{@elem_id} .display span").text('')

    onClick_toggle: (event) ->
        $("##{@elem_id}").toggleClass('displaynone')
        $("\#ai-panel \#ai-toggle-#{@ship_str}").toggleClass('glow')


exportObj.shipAi = {}
class exportObj.shipAi.TieFighter extends EnemyAi
    name: 'TIE Fighter'
    id: 'tiefighter'
    defaultshow: true
    color_dict: {kturn3: 'red', kturn4: 'red'}
    genericMovement_dict: {
        ahead: {
            far: [
                ['straight', null, 5],
                ['straight', null, 5],
                ['straight', null, 5],
                ['straight', null, 4],
                ['straight', null, 4],
                ['straight', null, 3]],
            near: [
                ['bank', 'left', 2],
                ['bank', 'right', 2],
                ['straight', null, 2],
                ['straight', null, 2],
                ['kturn', null, 4],
                ['kturn', null, 4]],
        },
        aheadx: {
            far: [
                ['straight', null, 3],
                ['bank', 'x', 2],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['turn', 'x', 3]],
            near: [
                ['straight', null, 2],
                ['bank', 'x', 2],
                ['bank', 'x', 2],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'x', 1]],
        },
        flankx: {
            far: [
                ['bank', 'x', 3],
                ['turn', 'x', 3],
                ['bank', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 1]],
            near: [
                ['turn', 'x', 1],
                ['turn', 'x', 1],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['kturn', null, 3],
                ['kturn', null, 4]],
        },
        behindx: {
            far: [
                ['kturn', null, 4],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 1]],
            near: [
                ['turn', 'x', 1],
                ['turn', 'x', 1],
                ['turn', 'x', 2],
                ['kturn', null, 3],
                ['kturn', null, 4],
                ['kturn', null, 4]],
        },
        behind: {
            far: [
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['turn', 'left', 1],
                ['turn', 'right', 1]],
            near: [
                ['kturn', null, 4],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['turn', 'left', 3],
                ['turn', 'right', 3],
                ['straight', null, 5]],
        },
    }

class exportObj.shipAi.TieInterceptor extends EnemyAi
    name: 'TIE Interceptor'
    id: 'tieinterceptor'
    defaultshow: true
    color_dict: {kturn3: 'red', kturn5: 'red'}
    genericMovement_dict: {
        ahead: {
            far: [
                ['straight', null, 5],
                ['straight', null, 5],
                ['straight', null, 5],
                ['straight', null, 4],
                ['straight', null, 4],
                ['straight', null, 3]],
            near: [
                ['bank', 'left', 2],
                ['bank', 'right', 2],
                ['straight', null, 2],
                ['straight', null, 2],
                ['kturn', null, 5],
                ['kturn', null, 5]],
        },
        aheadx: {
            far: [
                ['straight', null, 3],
                ['bank', 'x', 2],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['turn', 'x', 3]],
            near: [
                ['straight', null, 2],
                ['bank', 'x', 2],
                ['bank', 'x', 2],
                ['kturn', null, 5],
                ['kturn', null, 5],
                ['turn', 'x', 1]],
        },
        flankx: {
            far: [
                ['bank', 'x', 3],
                ['turn', 'x', 3],
                ['bank', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 1]],
            near: [
                ['turn', 'x', 1],
                ['turn', 'x', 1],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['kturn', null, 3],
                ['kturn', null, 5]],
        },
        behindx: {
            far: [
                ['kturn', null, 5],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 1]],
            near: [
                ['turn', 'x', 1],
                ['turn', 'x', 1],
                ['turn', 'x', 2],
                ['kturn', null, 3],
                ['kturn', null, 5],
                ['kturn', null, 5]],
        },
        behind: {
            far: [
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['turn', 'left', 1],
                ['turn', 'right', 1]],
            near: [
                ['kturn', null, 5],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['turn', 'left', 3],
                ['turn', 'right', 3],
                ['straight', null, 5]],
        },
    }

class exportObj.shipAi.TieAdvanced extends EnemyAi
    name: 'TIE Advanced'
    id: 'tieadvanced'
    color_dict: {kturn4: 'red'}
    genericMovement_dict: {
        ahead: {
            far: [
                ['straight', null, 5],
                ['straight', null, 5],
                ['straight', null, 5],
                ['straight', null, 4],
                ['straight', null, 4],
                ['straight', null, 3]],
            near: [
                ['bank', 'left', 1],
                ['bank', 'right', 1],
                ['straight', null, 2],
                ['straight', null, 2],
                ['kturn', null, 4],
                ['kturn', null, 4]],
        },
        aheadx: {
            far: [
                ['straight', null, 3],
                ['bank', 'x', 2],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['turn', 'x', 3]],
            near: [
                ['straight', null, 2],
                ['bank', 'x', 1],
                ['bank', 'x', 1],
                ['bank', 'x', 1],
                ['kturn', null, 4],
                ['kturn', null, 4]],
        },
        flankx: {
            far: [
                ['bank', 'x', 1],
                ['bank', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 3],
                ['turn', 'x', 3]],
            near: [
                ['bank', 'x', 1],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2]],
        },
        behindx: {
            far: [
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2]],
            near: [
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['bank', 'x', 1]],
        },
        behind: {
            far: [
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'left', 2],
                ['turn', 'right', 2]],
            near: [
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'left', 3],
                ['turn', 'right', 3]],
        },
    }

class exportObj.shipAi.TieBomber extends EnemyAi
    name: 'TIE Bomber'
    id: 'tiebomber'
    color_dict: {kturn5: 'red', turnleft2: 'red', turnright2: 'red'}
    genericMovement_dict: {
        ahead: {
            far: [
                ['straight', null, 4],
                ['straight', null, 4],
                ['straight', null, 4],
                ['straight', null, 3],
                ['straight', null, 3],
                ['straight', null, 2]],
            near: [
                ['bank', 'left', 1],
                ['bank', 'right', 1],
                ['straight', null, 1],
                ['straight', null, 1],
                ['straight', null, 1],
                ['kturn', null, 5]],
        },
        aheadx: {
            far: [
                ['straight', null, 2],
                ['bank', 'x', 2],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['turn', 'x', 3]],
            near: [
                ['turn', 'x', 3],
                ['straight', null, 1],
                ['bank', 'x', 1],
                ['bank', 'x', 1],
                ['bank', 'x', 1],
                ['kturn', null, 5]],
        },
        flankx: {
            far: [
                ['bank', 'x', 3],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 3],
                ['turn', 'x', 3],
                ['turn', 'x', 3]],
            near: [
                ['bank', 'x', 1],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2]],
        },
        behindx: {
            far: [
                ['kturn', null, 5],
                ['kturn', null, 5],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 3],
                ['turn', 'x', 3]],
            near: [
                ['kturn', null, 5],
                ['kturn', null, 5],
                ['kturn', null, 5],
                ['turn', 'x', 3],
                ['turn', 'x', 3],
                ['turn', 'x', 2]],
        },
        behind: {
            far: [
                ['kturn', null, 5],
                ['kturn', null, 5],
                ['kturn', null, 5],
                ['kturn', null, 5],
                ['turn', 'left', 2],
                ['turn', 'right', 2]],
            near: [
                ['kturn', null, 5],
                ['kturn', null, 5],
                ['kturn', null, 5],
                ['kturn', null, 5],
                ['turn', 'left', 3],
                ['turn', 'right', 3]],
        },
    }

class exportObj.shipAi.TieDefender extends EnemyAi
    name: 'TIE Defender'
    id: 'tiedefender'
    color_dict: {turnleft1: 'red', turnright1: 'red', turnleft2: 'red', turnright2: 'red'}
    genericMovement_dict: {
        ahead: {
            far: [
                ['straight', null, 5],
                ['straight', null, 5],
                ['straight', null, 5],
                ['straight', null, 4],
                ['straight', null, 4],
                ['straight', null, 3]],
            near: [
                ['bank', 'left', 1],
                ['bank', 'right', 1],
                ['straight', null, 2],
                ['straight', null, 2],
                ['kturn', null, 4],
                ['kturn', null, 4]],
        },
        aheadx: {
            far: [
                ['straight', null, 2],
                ['bank', 'x', 2],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['turn', 'x', 3]],
            near: [
                ['straight', null, 2],
                ['bank', 'x', 1],
                ['bank', 'x', 1],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'x', 1]],
        },
        flankx: {
            far: [
                ['bank', 'x', 3],
                ['bank', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 3],
                ['turn', 'x', 3],
                ['turn', 'x', 3]],
            near: [
                ['bank', 'x', 1],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'x', 2],
                ['turn', 'x', 1],
                ['turn', 'x', 1]],
        },
        behindx: {
            far: [
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 1]],
            near: [
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 1]],
        },
        behind: {
            far: [
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'left', 1],
                ['turn', 'right', 1]],
            near: [
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'left', 3],
                ['turn', 'right', 3]],
        },
    }

class exportObj.shipAi.TiePhantom extends EnemyAi
    name: 'TIE Phantom'
    id: 'tiephantom'
    color_dict: {kturn3: 'red', kturn4: 'red'}
    genericMovement_dict: {
        ahead: {
            far: [
                ['straight', null, 4],
                ['straight', null, 4],
                ['straight', null, 4],
                ['straight', null, 3],
                ['straight', null, 3],
                ['straight', null, 2]],
            near: [
                ['bank', 'left', 2],
                ['bank', 'right', 2],
                ['straight', null, 2],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['kturn', null, 4]],
        },
        aheadx: {
            far: [
                ['straight', null, 3],
                ['bank', 'x', 2],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['turn', 'x', 3]],
            near: [
                ['straight', null, 2],
                ['bank', 'x', 2],
                ['kturn', null, 4],
                ['kturn', null, 4],
                ['turn', 'x', 1],
                ['turn', 'x', 1]],
        },
        flankx: {
            far: [
                ['bank', 'x', 2],
                ['turn', 'x', 3],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 1],
                ['turn', 'x', 1]],
            near: [
                ['turn', 'x', 1],
                ['turn', 'x', 1],
                ['turn', 'x', 1],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['kturn', null, 4]],
        },
        behindx: {
            far: [
                ['kturn', null, 4],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 1]],
            near: [
                ['turn', 'x', 1],
                ['turn', 'x', 1],
                ['turn', 'x', 2],
                ['kturn', null, 3],
                ['kturn', null, 4],
                ['kturn', null, 4]],
        },
        behind: {
            far: [
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['turn', 'left', 1],
                ['turn', 'right', 1]],
            near: [
                ['kturn', null, 4],
                ['kturn', null, 3],
                ['kturn', null, 3],
                ['turn', 'left', 3],
                ['turn', 'right', 3],
                ['straight', null, 4]],
        },
    }

class exportObj.shipAi.LambdaShuttle extends EnemyAi
    name: 'Lambda Shuttle'
    id: 'lambdaclassshuttle'
    color_dict: {stop0: 'red', turnleft2: 'red', turnright2: 'red', bankleft3: 'red', bankright3: 'red'}
    genericMovement_dict: {
        ahead: {
            far: [
                ['straight', null, 3],
                ['straight', null, 3],
                ['straight', null, 3],
                ['straight', null, 2],
                ['straight', null, 2],
                ['straight', null, 1]],
            near: [
                ['stop', null, 0],
                ['stop', null, 0],
                ['stop', null, 0],
                ['straight', null, 1],
                ['bank', 'left', 1],
                ['bank', 'right', 1]],
        },
        aheadx: {
            far: [
                ['straight', null, 2],
                ['bank', 'x', 3],
                ['bank', 'x', 2],
                ['bank', 'x', 2],
                ['bank', 'x', 2],
                ['turn', 'x', 2]],
            near: [
                ['stop', null, 0],
                ['straight', null, 1],
                ['bank', 'x', 1],
                ['bank', 'x', 1],
                ['bank', 'x', 1],
                ['turn', 'x', 2]],
        },
        flankx: {
            far: [
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['bank', 'x', 2],
                ['bank', 'x', 3]],
            near: [
                ['stop', null, 0],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['bank', 'x', 1],
                ['bank', 'x', 2]],
        },
        behindx: {
            far: [
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['bank', 'x', 1],
                ['bank', 'x', 1]],
            near: [
                ['stop', null, 0],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['bank', 'x', 2],
                ['bank', 'x', 3]],
        },
        behind: {
            far: [
                ['turn', 'left', 2],
                ['turn', 'left', 2],
                ['turn', 'left', 2],
                ['turn', 'right', 2],
                ['turn', 'right', 2],
                ['turn', 'right', 2]],
            near: [
                ['stop', null, 0],
                ['stop', null, 0],
                ['turn', 'left', 2],
                ['turn', 'right', 2],
                ['bank', 'left', 3],
                ['bank', 'right', 3]],
        },
    }

class exportObj.shipAi.Vt49Decimator extends EnemyAi
    name: 'VT-49 Decimator'
    id: 'vt49decimator'
    color_dict: {}
    genericMovement_dict: {
        ahead: {
            far: [
                ['straight', null, 4],
                ['straight', null, 4],
                ['straight', null, 4],
                ['straight', null, 3],
                ['straight', null, 3],
                ['straight', null, 2]],
            near: [
                ['straight', null, 4],
                ['straight', null, 4],
                ['bank', 'left', 3],
                ['bank', 'right', 3],
                ['turn', 'left', 3],
                ['turn', 'right', 3]],
        },
        aheadx: {
            far: [
                ['straight', null, 4],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['bank', 'x', 2],
                ['turn', 'x', 3]],
            near: [
                ['straight', null, 4],
                ['straight', null, 4],
                ['bank', 'x', 3],
                ['bank', 'y', 3],
                ['bank', 'y', 2],
                ['turn', 'y', 2]],
        },
        flankx: {
            far: [
                ['bank', 'x', 3],
                ['turn', 'x', 3],
                ['turn', 'x', 3],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['bank', 'x', 1]],
            near: [
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['turn', 'x', 3],
                ['bank', 'x', 2],
                ['turn', 'x', 2],
                ['bank', 'x', 1]],
        },
        behindx: {
            far: [
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 3],
                ['turn', 'x', 3],
                ['bank', 'x', 1]],
            near: [
                ['bank', 'x', 3],
                ['bank', 'x', 3],
                ['bank', 'x', 2],
                ['turn', 'x', 2],
                ['turn', 'x', 2],
                ['bank', 'x', 1]],
        },
        behind: {
            far: [
                ['turn', 'left', 2],
                ['turn', 'left', 2],
                ['turn', 'left', 2],
                ['turn', 'right', 2],
                ['turn', 'right', 2],
                ['turn', 'right', 2]],
            near: [
                ['turn', 'left', 3],
                ['turn', 'left', 2],
                ['bank', 'left', 1],
                ['turn', 'right', 3],
                ['turn', 'right', 2],
                ['bank', 'right', 1]],
        },
    }

