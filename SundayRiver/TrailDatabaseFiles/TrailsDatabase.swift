//
//  TrailsDatabase.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/26/22.
//

import Foundation
import MapKit


enum Difficulty
{
    case easy
    case intermediate
    case advanced
    case expertsOnly
    case lift
    case terrainPark
}

enum userStatus
{
    case guest
    case member
}


class ImageAnnotation : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var colour: UIColor?
    var difficulty: Difficulty?
    var trailReport : ImageAnnotation?
    var image: UIImage?
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.difficulty = nil
        self.trailReport = nil
        self.image = nil
        self.colour = UIColor.white
    }
}


class TrailsDatabase : NSObject {
    
    static let CommonlyJunctionedTrailNames = ["Tin Woodsman", "Vortex", "Northern Lights", "Airglow", "Dream Maker", "Grand Rapids"]

    static let Lifts =
    [Lift(name: "Jordan", annotations: [createAnnotation(title: "Jordan Lift", latitude: 44.4717323221508, longitude: -70.89489548889809, difficulty: .lift), createAnnotation(title: "Top of Jordan", latitude: 44.46239249702886, longitude: -70.90754291060291, difficulty: .lift)]),

     Lift(name: "Aurora", annotations: [createAnnotation(title: "Aurora Lift", latitude: 44.471807197499686, longitude: -70.88638321700229, difficulty: .lift), createAnnotation(title: "Top of Aurora", latitude: 44.46308843335746, longitude: -70.88975714956065, difficulty: .lift)]),

     Lift(name: "Jordan Double", annotations: [createAnnotation(title: "Jordan Double", latitude: 44.47185220242018, longitude: -70.8868831674901, difficulty: .lift), createAnnotation(title: "Jordan Double", latitude: 44.471727779664356, longitude: -70.89391070242685, difficulty: .lift)]),
     
     Lift(name: "Southridge Chondola", annotations: [createAnnotation(title: "Chondola", latitude: 44.473098413827294, longitude: -70.85745769220948, difficulty: .lift), createAnnotation(title: "Top of Chondola", latitude: 44.468643133308056, longitude: -70.87985424949272, difficulty: .lift)]),
    
     Lift(name: "North Peak Express", annotations: [createAnnotation(title: "North Peak Express", latitude: 44.47392442992593, longitude: -70.86496661448741, difficulty: .lift), createAnnotation(title: "Top of North Peak Express", latitude: 44.47016716972932, longitude: -70.87984653186034, difficulty: .lift)]),
    
     Lift(name: "Quantum Leap Triple", annotations: [createAnnotation(title: "Quantum Leap Triple", latitude: 44.47135602096759, longitude: -70.88539833730681, difficulty: .lift), createAnnotation(title: "Top of Quantum Leap Triple", latitude: 44.469956233389304, longitude: -70.88004779413315, difficulty: .lift)]),
    
     Lift(name: "Spruce Triple", annotations: [createAnnotation(title: "Spruce", latitude: 44.46956649226089, longitude: -70.86889775439303, difficulty: .lift), createAnnotation(title: "Top of Spruce", latitude: 44.463183391461904, longitude: -70.88237835188288, difficulty: .lift)]),
     Lift(name: "Southridge Express", annotations: [createAnnotation(title: "South Ridge Express", latitude: 44.47349766967515, longitude: -70.85804872495724, difficulty: .lift), createAnnotation(title: "topSouthridge", latitude: 44.47140473269554, longitude: -70.8690669747966, difficulty: .lift)]),
     Lift(name: "Barker Express", annotations: [createAnnotation(title: "Barker Express", latitude: 44.470336293576615, longitude: -70.86235471500864, difficulty: .lift), createAnnotation(title: "topBarker", latitude: 44.45939892927216, longitude: -70.87209354638405, difficulty: .lift)]),
     Lift(name: "Locke Triple", annotations: [createAnnotation(title: "Locke Triple", latitude: 44.46939397490112, longitude: -70.8620473764752, difficulty: .lift), createAnnotation(title: "topLocke", latitude: 44.45732043619839, longitude: -70.86721732867319, difficulty: .lift)]),
     Lift(name: "Tempest Quad", annotations: [createAnnotation(title: "Tempest Quad", latitude: 44.46906778899057, longitude: -70.84833766968724, difficulty: .lift), createAnnotation(title: "topTempest", latitude: 44.464289208270316, longitude: -70.86019280483269, difficulty: .lift)]),
     Lift(name: "Little White Cap Quad", annotations: [createAnnotation(title: "Little White Cap Quad", latitude: 44.46919453030537, longitude: -70.84688269791349, difficulty: .lift), createAnnotation(title: "topLWC", latitude: 44.46127568629244, longitude: -70.85098869452358, difficulty: .lift)]),
     Lift(name: "White Heat Quad", annotations: [createAnnotation(title: "White Heat Quad", latitude: 44.46537254108104, longitude: -70.85170418417664, difficulty: .lift), createAnnotation(title: "topWHQ", latitude: 44.458371170992024, longitude: -70.8598457828036, difficulty: .lift)])]
    
    static let barkerTrails : [Trail] = [
        Trail(name: "Three Mile Trail", difficulty: "Easy", annotations: [createAnnotation(title: "Three Mile Trail", latitude: 44.45995830676152, longitude: -70.87507133018418, difficulty: .easy), createAnnotation(title: "bend13ML", latitude: 44.45972825558672, longitude: -70.87556509196926, difficulty: .easy), createAnnotation(title: "bend23ML", latitude: 44.46103810206512, longitude: -70.87679718913374, difficulty: .easy), createAnnotation(title: "sluiceJunction3ML", latitude: 44.464324531330846, longitude: -70.87687849056759, difficulty: .easy), createAnnotation(title: "gnarniaJunction3ML", latitude: 44.465957595619486, longitude: -70.8768278709139, difficulty: .easy), createAnnotation(title: "RBJunction3ML", latitude: 44.46666992104078, longitude: -70.87694136884294, difficulty: .easy), createAnnotation(title: "AEJunction3ML", latitude: 44.46748978213407, longitude: -70.87829904642872, difficulty: .easy), createAnnotation(title: "bend33ML", latitude: 44.46769951569971, longitude: -70.87866743914817, difficulty: .easy), createAnnotation(title: "end3ML", latitude: 44.468481491163516, longitude: -70.87867359271134, difficulty: .easy)]),
        Trail(name: "Lazy River", difficulty: "Intermediate", annotations: [createAnnotation(title: "Lazy River", latitude: 44.458918811247116, longitude: -70.87286678674761, difficulty: .easy), createAnnotation(title: "bend1LR", latitude: 44.45975604858868, longitude: -70.87375252691037, difficulty: .easy), createAnnotation(title: "3MLJunctionLR", latitude: 44.46004325902246, longitude: -70.87506172749464, difficulty: .easy), createAnnotation(title: "bend2LR", latitude: 44.46123880707136, longitude: -70.87588644774648, difficulty: .intermediate), createAnnotation(title: "bend3LR", latitude: 44.461611844923105, longitude: -70.8752208740192, difficulty: .intermediate), createAnnotation(title: "bend4LR", latitude: 44.46401321903339, longitude: -70.8742869902883, difficulty: .intermediate), createAnnotation(title: "sluiceJunctionLR", latitude: 44.46500701360254, longitude: -70.87456240448098, difficulty: .intermediate), createAnnotation(title: "gnarniaJunctionLR", latitude: 44.467083004155505, longitude: -70.87430538506386, difficulty: .intermediate), createAnnotation(title: "RBJunctionLR", latitude: 44.46761344275562, longitude: -70.87362002109518, difficulty: .intermediate), createAnnotation(title: "bend5LR", latitude: 44.46870630852191, longitude: -70.87166224609365, difficulty: .intermediate), createAnnotation(title: "AEJunctionLR", latitude: 44.46944563240094, longitude: -70.87141169656348, difficulty: .intermediate), createAnnotation(title: "GRJunctionLR", latitude: 44.470136513568576, longitude: -70.87047939858917, difficulty: .intermediate), createAnnotation(title: "endLR", latitude: 44.470801087998225, longitude: -70.87009348888205, difficulty: .intermediate)]),
        Trail(name: "Sluice", difficulty: "Intermediate", annotations: [createAnnotation(title: "Sluice", latitude: 44.46431335555877, longitude: -70.87666657652473, difficulty: .intermediate), createAnnotation(title: "bend1Sluice", latitude: 44.46480932438971, longitude: -70.87626855163778, difficulty: .intermediate), createAnnotation(title: "endSluice", latitude: 44.46494612702607, longitude: -70.87483090477522, difficulty: .intermediate)]),
        Trail(name: "Right Stuff", difficulty: "Advanced", annotations: [createAnnotation(title: "Right Stuff", latitude: 44.45967555335523, longitude: -70.87228900050134, difficulty: .advanced), createAnnotation(title: "bend1RS", latitude: 44.46211562332595, longitude: -70.87324457738133, difficulty: .advanced), createAnnotation(title: "bend2RS", latitude: 44.464038434182285, longitude: -70.87248702977574, difficulty: .advanced), createAnnotation(title: "bend3RS", latitude: 44.46654264712807, longitude: -70.86932668045823, difficulty: .advanced), createAnnotation(title: "LSPJunctionRS", latitude: 44.46751005332643, longitude: -70.8665321334552, difficulty: .advanced)]),
        Trail(name: "Agony", difficulty: "Expert's Only", annotations: [createAnnotation(title: "Agony", latitude: 44.45971601100833, longitude: -70.87176135368556, difficulty: .expertsOnly), createAnnotation(title: "TGJunctionAgony", latitude: 44.460472549774586, longitude: -70.87111695688282, difficulty: .expertsOnly), createAnnotation(title: "EndAgony", latitude: 44.46491262085675, longitude: -70.86704387714973, difficulty: .expertsOnly)]),
//        Trail(name: "Hollywood", difficulty: "Expert's Only", annotations: []),
        Trail(name: "Top Gun", difficulty: "Expert's Only", annotations: [createAnnotation(title: "Top Gun", latitude: 44.46052492553666, longitude: -70.87122997646192, difficulty: .expertsOnly), createAnnotation(title: "bend1TG", latitude: 44.4632487372244, longitude: -70.87123330508894, difficulty: .expertsOnly), createAnnotation(title: "LSPJunctionTG", latitude: 44.46695531620989, longitude: -70.86638410668483, difficulty: .expertsOnly)]),
        Trail(name: "Ecstasy", difficulty: "Intermediate", annotations: [createAnnotation(title: "Ecstasy", latitude: 44.45966692011528, longitude: -70.87135166364119, difficulty: .intermediate), createAnnotation(title: "bend1Ecstasy", latitude: 44.460016590788584, longitude: -70.87084852853677, difficulty: .intermediate), createAnnotation(title: "bend2Ecstasy", latitude: 44.46032795232815, longitude: -70.86718600985445, difficulty: .intermediate), createAnnotation(title: "southPawJunctionEcstasy", latitude: 44.461297881305626, longitude: -70.8663917106066, difficulty: .intermediate), createAnnotation(title: "uppercutJunctionEcstasy", latitude: 44.4613493437183, longitude: -70.86555394520701, difficulty: .intermediate)]),
        Trail(name: "Jungle Road", difficulty: "Intermediate", annotations: [createAnnotation(title: "Jungle Road", latitude: 44.45966830075108, longitude: -70.87132308134012, difficulty: .intermediate), createAnnotation(title: "bend1JR", latitude: 44.459513174807036, longitude: -70.87016928026638, difficulty: .intermediate), createAnnotation(title: "bend2JR", latitude: 44.45902428223, longitude: -70.86971606313978, difficulty: .intermediate), createAnnotation(title: "GPJunctionJR", latitude: 44.45888651945049, longitude: -70.86907843269005, difficulty: .intermediate), createAnnotation(title: "USPJunctionJR", latitude: 44.45866032666825, longitude: -70.86775321054346, difficulty: .intermediate)]),
        Trail(name: "Lower Upper Cut", difficulty: "Intermediate", annotations: [createAnnotation(title: "Lower Uppercut", latitude: 44.461503816429364, longitude: -70.86549642959537, difficulty: .intermediate), createAnnotation(title: "bottomUppercut", latitude: 44.46241757333772, longitude: -70.8651424743854, difficulty: .intermediate)]),
        Trail(name: "Southpaw", difficulty: "Intermediate", annotations: [createAnnotation(title: "South Paw", latitude: 44.46137352810597, longitude: -70.86642583630629, difficulty: .intermediate), createAnnotation(title: "southPawSplit", latitude: 44.46213546672406, longitude: -70.86638870223543, difficulty: .intermediate), createAnnotation(title: "LSPJunctionSP", latitude: 44.46253123478195, longitude: -70.86535354781799, difficulty: .intermediate), createAnnotation(title: "bend1SP", latitude: 44.46276805273417, longitude: -70.86601223095431, difficulty: .intermediate), createAnnotation(title: "bend2SP", latitude: 44.46319899549631, longitude: -70.86688265387109, difficulty: .intermediate), createAnnotation(title: "bend3SouthPaw", latitude: 44.46375343519025, longitude: -70.86722425833486, difficulty: .intermediate), createAnnotation(title: "agonyJunctionSP", latitude: 44.464981534834564, longitude: -70.86704927562877, difficulty: .intermediate), createAnnotation(title: "LSPJunction2SP", latitude: 44.466084243678694, longitude: -70.86595438952699, difficulty: .intermediate)]),
        Trail(name: "Lower Sunday Punch", difficulty: "Intermediate", annotations: [createAnnotation(title: "Lower Sunday Punch", latitude: 44.462333820213146, longitude: -70.86448440473603, difficulty: .intermediate), createAnnotation(title: "SPJunctionLSP", latitude: 44.4625240631385, longitude: -70.86520501198373, difficulty: .intermediate), createAnnotation(title: "bend1SP", latitude: 44.46367022702908, longitude: -70.86500787270711, difficulty: .intermediate), createAnnotation(title: "SP&RCJunctionLSP", latitude: 44.466043015366544, longitude: -70.86592477230046, difficulty: .intermediate), createAnnotation(title: "TGJunctionLSP", latitude: 44.4669271429763, longitude: -70.8661816527247, difficulty: .intermediate), createAnnotation(title: "RSJunctionLSP", latitude: 44.46749072664456, longitude: -70.86647954730529, difficulty: .intermediate), createAnnotation(title: "TTJunctionLSP", latitude: 44.46954650476462, longitude: -70.86438018168907, difficulty: .intermediate), createAnnotation(title: "endLSP", latitude: 44.46971832425021, longitude: -70.86315139834717, difficulty: .intermediate)]),
        Trail(name: "Rocking Chair", difficulty: "Intermediate", annotations: [createAnnotation(title: "Rocking Chair", latitude: 44.46633242158953, longitude: -70.86542313921537, difficulty: .intermediate), createAnnotation(title: "bend1RC", latitude: 44.46893816110395, longitude: -70.86396468658349, difficulty: .intermediate), createAnnotation(title: "endRC", latitude: 44.46955007566205, longitude: -70.86287985731924, difficulty: .intermediate)]),
        Trail(name: "Tightwire", difficulty: "Advanced", annotations: [createAnnotation(title: "Tightwire", latitude: 44.46315831820998, longitude: -70.86468326750321, difficulty: .advanced), createAnnotation(title: "bend1TW", latitude: 44.46641701498706, longitude: -70.86342087036127, difficulty: .advanced), createAnnotation(title: "RCJunctionTW", latitude: 44.467342723580636, longitude: -70.86453099495536, difficulty: .advanced)])]
    
    static let southRidgeTrails : [Trail] = [
        Trail(name: "Ridge Run", difficulty: "Easy", annotations: [createAnnotation(title: "Ridge Run", latitude: 44.47162071063281, longitude: -70.86932648218762, difficulty: .easy), createAnnotation(title: "EFJunctionRR", latitude: 44.47261225258012, longitude: -70.86990943502828, difficulty: .easy), createAnnotation(title: "3DJunctionRR", latitude: 44.473566373346806, longitude: -70.87061356821667, difficulty: .easy), createAnnotation(title: "bend1RR", latitude: 44.47397519114789, longitude: -70.87096271327214, difficulty: .easy), createAnnotation(title: "T72JunctionRR", latitude: 44.47471498969679, longitude: -70.87081490034599, difficulty: .easy), createAnnotation(title: "DMJunctionRR", latitude: 44.47547018726526, longitude: -70.87077704736517, difficulty: .easy), createAnnotation(title: "STJunctionRR", latitude: 44.47549070157672, longitude: -70.87076078836633, difficulty: .easy), createAnnotation(title: "LCJunctionRR", latitude: 44.47642562084904, longitude: -70.87058426814676, difficulty: .easy), createAnnotation(title: "bend2RR", latitude: 44.477270343557755, longitude: -70.86901116770413, difficulty: .easy), createAnnotation(title: "bend3RR", latitude: 44.47805677665824, longitude: -70.86628295857128, difficulty: .easy), createAnnotation(title: "bend4RR", latitude: 44.477370343898286, longitude: -70.86223738949299, difficulty: .easy), createAnnotation(title: "bend5RR", latitude: 44.47528005782332, longitude: -70.85938331721208, difficulty: .easy), createAnnotation(title: "bend6RR", latitude: 44.474310447199095, longitude: -70.8586525348936, difficulty: .easy), createAnnotation(title: "endRR", latitude: 44.473842509608566, longitude: -70.85888489822734, difficulty: .easy)]),
        Trail(name: "Lower Escapade", difficulty: "Easy", annotations: [createAnnotation(title: "Lower Escapade", latitude: 44.47186608016329, longitude: -70.86945449960109, difficulty: .easy), createAnnotation(title: "BroadwayJunctionLE", latitude: 44.47186608016329, longitude: -70.86945449960109, difficulty: .easy), createAnnotation(title: "NWJunctionLE", latitude: 44.47315536119423, longitude: -70.86574560528885, difficulty: .easy), createAnnotation(title: "endLE", latitude: 44.473892525500894, longitude: -70.86457915169618, difficulty: .easy)]),
        Trail(name: "Broadway", difficulty: "Easy", annotations: [createAnnotation(title: "Broadway", latitude: 44.471513238602334, longitude: -70.86920055180396, difficulty: .easy), createAnnotation(title: "NWJunctionBroadway", latitude: 44.471887698950034, longitude: -70.8661872983771, difficulty: .easy), createAnnotation(title: "MBJunctionBroadway", latitude: 44.47158910946508, longitude: -70.8644627972387, difficulty: .easy), createAnnotation(title: "WVJunctionBroadway", latitude: 44.47170856243638, longitude: -70.86377512631796, difficulty: .easy), createAnnotation(title: "WLJunctionBroadway", latitude: 44.471612194301656, longitude: -70.86164965039356, difficulty: .easy), createAnnotation(title: "endBroadway", latitude: 44.473152286875425, longitude: -70.85843285655504, difficulty: .easy)]),
        Trail(name: "Lower Lazy River", difficulty: "Easy", annotations: [createAnnotation(title: "Lower Lazy River", latitude: 44.47094252731932, longitude: -70.86882825160487, difficulty: .easy), createAnnotation(title: "bend1LLR", latitude: 44.470738578779034, longitude: -70.8675201983097, difficulty: .easy), createAnnotation(title: "broadwayJunctionLLR", latitude: 44.47131969568009, longitude: -70.86401012794902, difficulty: .easy), createAnnotation(title: "endLLR", latitude: 44.47078330161824, longitude: -70.86233471871473, difficulty: .easy)]),
        Trail(name: "Thataway", difficulty: "Easy", annotations: [createAnnotation(title: "Thataway", latitude: 44.47085254666974, longitude: -70.86896670777054, difficulty: .easy), createAnnotation(title: "endThataway", latitude: 44.46975772026796, longitude: -70.86886894893023, difficulty: .easy)]),
        Trail(name: "Mixing Bowl", difficulty: "Easy", annotations: [createAnnotation(title: "Mixing Bowl", latitude: 44.471302120911304, longitude: -70.86878079872398, difficulty: .easy), createAnnotation(title: "bend1MB", latitude: 44.47132044453957, longitude: -70.8665553011726, difficulty: .easy), createAnnotation(title: "endMixingBowl", latitude: 44.47160896486826, longitude: -70.86496105485335, difficulty: .easy)]),
        Trail(name: "Lower Chondi Line", difficulty: "Easy", annotations: [createAnnotation(title: "Lower Chondi Line", latitude: 44.47091183832565, longitude: -70.86718397308259, difficulty: .easy), createAnnotation(title: "endLCL", latitude: 44.47143002814015, longitude: -70.86490148014812, difficulty: .easy)]),
        Trail(name: "WhoVille", difficulty: "Terrain Park", annotations: [createAnnotation(title: "Who-Ville", latitude: 44.47189644908563, longitude: -70.86329936753248, difficulty: .terrainPark), createAnnotation(title: "endWV", latitude: 44.47308643515055, longitude: -70.85954960379576, difficulty: .terrainPark)]),
        Trail(name: "Wonderland", difficulty: "Terrain Park", annotations: [createAnnotation(title: "Wonderland", latitude: 44.47155200691823, longitude: -70.86108394226666, difficulty: .terrainPark), createAnnotation(title: "endWonderland", latitude: 44.471703973166186, longitude: -70.86008848766531, difficulty: .terrainPark)]),
        Trail(name: "Northway", difficulty: "Easy", annotations: [createAnnotation(title: "Northway", latitude: 44.47220538401174, longitude: -70.8662171943399, difficulty: .easy), createAnnotation(title: "LEJunctionNW", latitude: 44.47315536119423, longitude: -70.86594930854713, difficulty: .easy), createAnnotation(title: "EFJunctionNW", latitude: 44.47365565297179, longitude: -70.86574560528885, difficulty: .easy), createAnnotation(title: "endNW", latitude: 44.47442726961685, longitude: -70.8656957450711, difficulty: .easy)]),
        Trail(name: "Spectator", difficulty: "Easy", annotations: [createAnnotation(title: "Spectator", latitude: 44.47205048836813, longitude: -70.86574022287715, difficulty: .easy), createAnnotation(title: "sundanceJunctionSpectator", latitude: 44.472470386120186, longitude: -70.86327947361386, difficulty: .easy), createAnnotation(title: "endSpectator", latitude: 44.47326843184697, longitude: -70.85944443654387, difficulty: .easy)]),
        Trail(name: "Double Dipper", difficulty: "Easy", annotations: [createAnnotation(title: "Double Dipper", latitude: 44.47221857294215, longitude: -70.8658617554617, difficulty: .easy), createAnnotation(title: "DMJunctionDD", latitude: 44.47307378992409, longitude: -70.86191876720088, difficulty: .easy), createAnnotation(title: "endDD", latitude: 44.47350477003316, longitude: -70.85933421055354, difficulty: .easy)]),
        Trail(name: "Sundance", difficulty: "Easy", annotations: [createAnnotation(title: "Sundance", latitude: 44.47216841473903, longitude: -70.8634803194262, difficulty: .easy), createAnnotation(title: "DD&SPRJunctionSD", latitude: 44.472564511416515, longitude: -70.86321930085626, difficulty: .easy), createAnnotation(title: "RRJunctionSD", latitude: 44.47319380222498, longitude: -70.86221130612768, difficulty: .easy), createAnnotation(title: "bend1Sundance", latitude: 44.47362558473599, longitude: -70.86151793333684, difficulty: .easy), createAnnotation(title: "botSundance", latitude: 44.47378191784132, longitude: -70.85906270396109, difficulty: .easy)]),
        Trail(name: "Second Thoughts", difficulty: "Easy", annotations: [createAnnotation(title: "Second Thoughts", latitude: 44.47638729191411, longitude: -70.870552774431, difficulty: .easy), createAnnotation(title: "bend1ST", latitude: 44.47629604259682, longitude: -70.86976874309151, difficulty: .easy), createAnnotation(title: "endSecondThoughts", latitude: 44.475530029337875, longitude: -70.86868889749921, difficulty: .easy)]),
        Trail(name: "Exit Right", difficulty: "Easy", annotations: [createAnnotation(title: "Exit Right", latitude: 44.47135372033121, longitude: -70.86992747990317, difficulty: .easy), createAnnotation(title: "endER", latitude: 44.470999193012005, longitude: -70.86952416392006, difficulty: .easy)]),
        Trail(name: "Exit Left", difficulty: "Easy", annotations: [createAnnotation(title: "Exit Left", latitude: 44.471211769327596, longitude: -70.8696094100586, difficulty: .easy), createAnnotation(title: "endEL", latitude: 44.471840249971066, longitude: -70.86955148201567, difficulty: .easy)])]
    
    static let lockeTrails  : [Trail] = [
        Trail(name: "Goat Path", difficulty: "Intermediate", annotations: []),
        Trail(name: "Upper Cut", difficulty: "Advanced", annotations: []),
        Trail(name: "Upper Sunday Punch", difficulty: "Intermedaite", annotations: []),
        Trail(name: "Locke Line", difficulty: "Advanced", annotations: []),
        Trail(name: "Jim's Whim", difficulty: "Advanced", annotations: []),
        Trail(name: "T2", difficulty: "Advanced", annotations: []),
        Trail(name: "Bim's Whim", difficulty: "Advanced", annotations: []),
        Trail(name: "Cascades", difficulty: "Intermediate", annotations: []),
        Trail(name: "Monday Morning", difficulty: "Advanced", annotations: []),
        Trail(name: "Bear Paw", difficulty: "Easy", annotations: []),
        Trail(name: "WildFire", difficulty: "Intermediate", annotations: []),
        Trail(name: "RoadRunner", difficulty: "Easy", annotations: []),
        Trail(name: "Snowbound", difficulty: "Advanced", annotations: [])]
    
    static let whiteCapTrails : [Trail] = [
        Trail(name: "Salvation", difficulty: "Intermediate", annotations: []),
        Trail(name: "Heat's Off", difficulty: "Intermediate", annotations: []),
        Trail(name: "Obsession", difficulty: "Advanced", annotations: []),
        Trail(name: "Chutzpah", difficulty: "Expert's Only", annotations: []),
        Trail(name: "White Heat", difficulty: "Expert's Only", annotations: []),
        Trail(name: "Shock Wave", difficulty: "Expert's Only", annotations: []),
        Trail(name: "Tempest", difficulty: "Advanced", annotations: []),
        Trail(name: "Jibe", difficulty: "Intermediate", annotations: []),
        Trail(name: "Heat's On", difficulty: "Intermediate", annotations: []),
        Trail(name: "Green Cheese", difficulty: "Easy", annotations: []),
        Trail(name: "Moonstruck", difficulty: "Easy", annotations: []),
        Trail(name: "Assumption", difficulty: "Intermediate", annotations: []),
        Trail(name: "Starlight", difficulty: "Easy", annotations: []),
        Trail(name: "Starstruck", difficulty: "Advanced", annotations: []),
        Trail(name: "Starwood", difficulty: "Advanced", annotations: []),
        Trail(name: "Starburst", difficulty: "Intermediate", annotations: [])]
    
    static let spruceTrails : [Trail] = [
        Trail(name: "Sirius", difficulty: "Easy", annotations: [createAnnotation(title: "Sirius", latitude: 44.46402015560722, longitude: -70.88287192667336, difficulty: .easy), createAnnotation(title: "endSirius", latitude: 44.463942115466686, longitude: -70.88490373252286, difficulty: .easy)]),
        Trail(name: "Upper Downdraft", difficulty: "Advanced", annotations: [createAnnotation(title: "Upper Downdraft", latitude: 44.46400513990251, longitude: -70.88273316778006, difficulty: .advanced), createAnnotation(title: "endDowndraft", latitude: 44.466716217333456, longitude: -70.88179847448035, difficulty: .advanced)]),
        Trail(name: "American Express", difficulty: "Intermediate", annotations: [createAnnotation(title: "American Express", latitude: 44.463729193167694, longitude: -70.88240279639638, difficulty: .intermediate), createAnnotation(title: "3MLJunctionAE", latitude: 44.46749143347745, longitude: -70.87835840418714, difficulty: .intermediate), createAnnotation(title: "bend1AE", latitude: 44.46860516845412, longitude: -70.87626493580731, difficulty: .intermediate), createAnnotation(title: "LRJunctionAE", latitude: 44.469746572790164, longitude: -70.87096508865964, difficulty: .intermediate)]),
        Trail(name: "Risky Business", difficulty: "Intermediate", annotations: [createAnnotation(title: "Risky Business", latitude: 44.46311714851905, longitude: -70.88223713245962, difficulty: .intermediate), createAnnotation(title: "bend1RB", latitude: 44.46403732360429, longitude: -70.879867409496, difficulty: .intermediate), createAnnotation(title: "bend2RB", latitude: 44.46633066617157, longitude: -70.87817420831703, difficulty: .intermediate), createAnnotation(title: "LRJunctionRB", latitude: 44.4675283503892, longitude: -70.87393140936513, difficulty: .intermediate)]),
        Trail(name: "Gnarnia", difficulty: "Expert's Only", annotations: [createAnnotation(title: "Gnarnia", latitude: 44.46504255184882, longitude: -70.87895361782995, difficulty: .expertsOnly), createAnnotation(title: "3MLJunctionGnarnia", latitude: 44.46591263745777, longitude: -70.87662346618372, difficulty: .expertsOnly), createAnnotation(title: "endGnarnia", latitude: 44.4670794114396, longitude: -70.87444062902327, difficulty: .expertsOnly)]),
        Trail(name: "Tourist Trap", difficulty: "Intermediate", annotations: [createAnnotation(title: "Tourist Trap", latitude: 44.46966600600691, longitude: -70.86793455018984, difficulty: .intermediate), createAnnotation(title: "OHJunctionTT", latitude: 44.469923339149595, longitude: -70.8664134016417, difficulty: .intermediate), createAnnotation(title: "endTT", latitude: 44.4695232038773, longitude: -70.86444287724876, difficulty: .intermediate)])]

    static let jordanTrails = [
        Trail(name: "Lollapalooza", difficulty: "Easy", annotations: [createAnnotation(title: "Lollapalooza", latitude: 44.462722133198504, longitude: -70.90801346676562, difficulty: .easy), createAnnotation(title: "Bend1Lolla", latitude: 44.46896537000713, longitude: -70.91051231074235, difficulty: .easy), createAnnotation(title: "Bend2Lolla", latitude: 44.47320361662942, longitude: -70.90307864281174, difficulty: .easy)]),
//1
        Trail(name: "Excalibur", difficulty: "Intermediate", annotations: [createAnnotation(title: "Excalibur", latitude: 44.4631862777165, longitude: -70.9075832927418, difficulty: .intermediate), createAnnotation(title: "bend1Excal", latitude: 44.46617465583206, longitude: -70.90667308737615, difficulty: .intermediate), createAnnotation(title: "midExcal", latitude: 44.46862888873153, longitude: -70.90326718886139, difficulty: .intermediate), createAnnotation(title: "botExcal", latitude: 44.47189010004125, longitude: -70.89631064496007, difficulty: .intermediate)]),
//2
        Trail(name: "Rogue Angel", difficulty: "Intermediate", annotations: [createAnnotation(title: "Rogue Angel", latitude: 44.46239298417106, longitude: -70.90692334506952, difficulty: .intermediate), createAnnotation(title: "MidRogue", latitude: 44.46633955610793, longitude: -70.90488744187293, difficulty: .intermediate), createAnnotation(title: "BotRogue", latitude: 44.470166735232745, longitude: -70.89713414576988, difficulty: .intermediate)]),
//3
        Trail(name: "iCaramba!", difficulty: "Experts Only", annotations: [createAnnotation(title: "iCaramba!", latitude: 44.463279337031715, longitude: -70.90610218702001, difficulty: .expertsOnly), createAnnotation(title: "botCaram", latitude: 44.46845226794425, longitude: -70.89911260345167, difficulty: .expertsOnly)]),
//4
        Trail(name: "Kansas", difficulty: "Easy", annotations: [createAnnotation(title: "Kansas", latitude: 44.46217702622463, longitude: -70.90716492905683, difficulty: .easy), createAnnotation(title: "bend1Kans", latitude: 44.4616778233863, longitude: -70.90722336991544, difficulty: .easy), createAnnotation(title: "ozJunctionKans", latitude: 44.46123534688093, longitude: -70.904483474769, difficulty: .easy), createAnnotation(title: "Tin Woodsman Junction of Kansasa", latitude: 44.460493480812396, longitude: -70.90366928411956, difficulty: .easy), createAnnotation(title: "bend2Kans", latitude: 44.460163849745214, longitude: -70.90148578576282, difficulty: .easy), createAnnotation(title: "bend3Kans", latitude: 44.46120348032429, longitude: -70.89721818116446, difficulty: .easy), createAnnotation(title: "bend4Kans", latitude: 44.461197797114906, longitude: -70.89514601904098, difficulty: .easy), createAnnotation(title: "endKans", latitude: 44.46460234637316, longitude: -70.89052023312101, difficulty: .easy)])]


    static let OzTrails : [Trail] = [
        Trail(name: "Tin Woodsman", difficulty: "Expert Only", annotations: [createAnnotation(title: "Tin Woodsman", latitude: 44.46000309303237, longitude: -70.90520452974141, difficulty: .expertsOnly), createAnnotation(title: "Tin Woodsman", latitude: 44.460493480812396, longitude: -70.90366928411956, difficulty: .expertsOnly), createAnnotation(title: "endWoodsman", latitude: 44.46555178523853, longitude: -70.89955012783363, difficulty: .expertsOnly)])]
    
    static let AuroraTrails = [
        Trail(name: "Cyclone", difficulty: "Easy", annotations: [createAnnotation(title: "Cyclone", latitude: 44.46456443017323, longitude: -70.88952523556077, difficulty: .easy), createAnnotation(title: "Cyclone", latitude: 44.46558362151272, longitude: -70.89119954539368, difficulty: .easy), createAnnotation(title: "Poppy Fields Junction of Cyclone", latitude: 44.465180155636666, longitude: -70.89860031454471, difficulty: .easy), createAnnotation(title: "Woodsman Junction of Cyclone", latitude: 44.46618881509814, longitude: -70.89898577127133, difficulty: .easy), createAnnotation(title: "iCaramba Junction of Cyclone", latitude: 44.468756233263775, longitude: -70.89862601165983, difficulty: .easy), createAnnotation(title: "Rogue Angel Junction of Cyclone", latitude: 44.47025995431891, longitude: -70.89703279052316, difficulty: .easy)]),
//7
        Trail(name: "Northern Lights", difficulty: "Intermediate", annotations: [createAnnotation(title: "Northern Lights", latitude: 44.463074702413536, longitude: -70.89016787184919, difficulty: .intermediate), createAnnotation(title: "witchWayNLJunction", latitude: 44.463381905172064, longitude: -70.89103146842714, difficulty: .intermediate), createAnnotation(title: "Northern Lights", latitude: 44.464494386806685, longitude: -70.89016611861871, difficulty: .intermediate), createAnnotation(title: "Cyclone Junction of Northern Lights", latitude: 44.46558362151272, longitude: -70.89119954539368, difficulty: .intermediate), createAnnotation(title: "Bend1NL", latitude: 44.46833930957292, longitude: -70.89052310618935, difficulty: .intermediate), createAnnotation(title: "fireStarJunction", latitude: 44.47011932648898, longitude: -70.88898936523161, difficulty: .intermediate)]),
//8
        Trail(name: "Witch Way", difficulty: "Intermediate", annotations: [createAnnotation(title: "Witch Way", latitude: 44.46331003750903, longitude: -70.89121983761352, difficulty: .intermediate), createAnnotation(title: "kansJunctionWitchWay", latitude: 44.463261798949524, longitude: -70.89272761114972, difficulty: .easy)]),
//9
        Trail(name: "Airglow", difficulty: "Advanced", annotations: [createAnnotation(title: "Airglow", latitude: 44.46295555779937, longitude: -70.88985528788332, difficulty: .advanced), createAnnotation(title: "Airglow", latitude: 44.46455484997939, longitude: -70.88938730025085, difficulty: .advanced), createAnnotation(title: "bend1Airglow", latitude: 44.46662949056471, longitude: -70.889916758492, difficulty: .advanced), createAnnotation(title: "blackHoleJunctionAirglow", latitude: 44.46796659263303, longitude: -70.88877674135661, difficulty: .advanced), createAnnotation(title: "bend2Airglow", latitude: 44.468647480083405, longitude: -70.88886118943041, difficulty: .advanced), createAnnotation(title: "botAirglow", latitude: 44.470649076580095, longitude: -70.88638637103126, difficulty: .advanced)]),
//10
        Trail(name: "Black Hole", difficulty: "Experts Only", annotations: [createAnnotation(title: "Blackhole", latitude: 44.46807563954452, longitude: -70.88849119199799, difficulty: .expertsOnly), createAnnotation(title: "botBlackHole", latitude: 44.468389612889254, longitude: -70.88751782797863, difficulty: .expertsOnly)]),
//11
        Trail(name: "Fire Star", difficulty: "Intermediate", annotations: [createAnnotation(title: "Firestar", latitude: 44.47027546367753, longitude: -70.8891562617633, difficulty: .intermediate), createAnnotation(title: "bend1Firestar", latitude: 44.47131672230162, longitude: -70.88964243473075, difficulty: .intermediate), createAnnotation(title: "bend2Firestar", latitude: 44.47067522787059, longitude: -70.89290882164136, difficulty: .intermediate), createAnnotation(title: "endFirestar", latitude: 44.47144966604338, longitude: -70.89408874939902, difficulty: .intermediate)]),
//12
        Trail(name: "Lights Out", difficulty: "Easy", annotations: [createAnnotation(title: "Lights Out", latitude: 44.46462524594242, longitude: -70.88910826784524, difficulty: .easy), createAnnotation(title: "Vortex Junction of Lights Out", latitude: 44.465846797045174, longitude: -70.88490523498776, difficulty: .easy), createAnnotation(title: "Upper Downdraft Junction of Lights Out", latitude: 44.466777506067146, longitude: -70.88153876394715, difficulty: .easy), createAnnotation(title: "endLightsOut", latitude: 44.46805596442271, longitude: -70.87977953790342, difficulty: .easy)]),
//14
        Trail(name: "Borealis", difficulty: "Easy", annotations: [createAnnotation(title: "Borealis", latitude: 44.46278170427937, longitude: -70.8895517763241, difficulty: .easy), createAnnotation(title: "bend1Borealis", latitude: 44.46248534478416, longitude: -70.88749443819064, difficulty: .easy), createAnnotation(title: "bend2Borealis", latitude: 44.4632449499215, longitude: -70.88551136371929, difficulty: .easy), createAnnotation(title: "vortexJunctionBorealis", latitude: 44.463909310290184, longitude: -70.88505530436773, difficulty: .easy), createAnnotation(title: "bend3Borealis", latitude: 44.46363692988425, longitude: -70.88602217785332, difficulty: .easy), createAnnotation(title: "endBorealis", latitude: 44.46456958036436, longitude: -70.88903941153798, difficulty: .easy)]),
//15
            Trail(name: "Vortex", difficulty: "Experts Only", annotations: [createAnnotation(title: "Vortex", latitude: 44.464086260411534, longitude: -70.88472455446858, difficulty: .expertsOnly), createAnnotation(title: "Vortex", latitude: 44.465875965885864, longitude: -70.88498076829377, difficulty: .expertsOnly), createAnnotation(title: "botVertex", latitude: 44.468935280601265, longitude: -70.88537258035753, difficulty: .expertsOnly)])]
    
    static let NorthPeakTrails = [
//13
        Trail(name: "Paradigm", difficulty: "Intermediate", annotations: [createAnnotation(title: "Paradigm", latitude: 44.46924157923843, longitude: -70.88073865336285, difficulty: .intermediate), createAnnotation(title: "bend1Paradigm", latitude: 44.4684834073092, longitude: -70.88413019219388, difficulty: .intermediate), createAnnotation(title: "Vortex Junction of Paradigm", latitude: 44.469151693786706, longitude: -70.88538404261011, difficulty: .intermediate), createAnnotation(title: "botParadigm", latitude: 44.4704364585831, longitude: -70.88622009554196, difficulty: .intermediate)]),
//16
        Trail(name: "Second Mile", difficulty: "Easy", annotations: [createAnnotation(title: "Second Mile", latitude: 44.46943702535925, longitude: -70.8789654647034, difficulty: .easy), createAnnotation(title: "Grand Rapids Junction of Second Mile", latitude: 44.47032406589279, longitude: -70.8781603365251, difficulty: .easy), createAnnotation(title: "Dream Maker Terrain Park Junction of Second Mile", latitude: 44.47088989413925, longitude: -70.87745792932414, difficulty: .easy), createAnnotation(title: "Escapade Junction of Second Mile", latitude: 44.471003653600654, longitude: -70.87608625181753, difficulty: .easy), createAnnotation(title: "3D Junction of Second Mile", latitude: 44.47182260784928, longitude: -70.87552946703043, difficulty: .easy), createAnnotation(title: "T72 Junction of Second Mile", latitude: 44.47240398079546, longitude: -70.87625359900291, difficulty: .easy), createAnnotation(title: "Dream Maker Junction of Second Mile", latitude: 44.472801490123636, longitude: -70.87674741037038, difficulty: .easy), createAnnotation(title: "endSM", latitude: 44.473345284763425, longitude: -70.87706137962822, difficulty: .easy)]),
//17
        Trail(name: "Quantum Leap", difficulty: "Experts Only", annotations: [createAnnotation(title: "Quantum Leap", latitude: 44.47035064728613, longitude: -70.88015704719764, difficulty: .expertsOnly), createAnnotation(title: "backsideJunctionQL", latitude: 44.47122504001555, longitude: -70.88101932258316, difficulty: .expertsOnly), createAnnotation(title: "bend1QL", latitude: 44.47168976730243, longitude: -70.8815677621026, difficulty: .expertsOnly), createAnnotation(title: "botQuantum", latitude: 44.47158096623986, longitude: -70.8846825390319, difficulty: .expertsOnly)]),
//18
        Trail(name: "Grand Rapids", difficulty: "Intermediate", annotations: [createAnnotation(title: "Grand Rapids", latitude: 44.469956233389304, longitude: -70.88004779413315, difficulty: .intermediate), createAnnotation(title: "Grand Rapids", latitude: 44.47031418756157, longitude: -70.87814112970221, difficulty: .intermediate), createAnnotation(title: "bend1GR", latitude: 44.46985270909712, longitude: -70.87704051030686, difficulty: .intermediate), createAnnotation(title: "Downdraft Junction of Grand Rapids", latitude: 44.47013967347965, longitude: -70.8751210217859, difficulty: .intermediate), createAnnotation(title: "bend2GR", latitude: 44.46988573312703, longitude: -70.87342068410626, difficulty: .intermediate), createAnnotation(title: "bend3GR", latitude: 44.470165629165166, longitude: -70.87145465636517, difficulty: .intermediate), createAnnotation(title: "lazyRiverJunction", latitude: 44.46994988535315, longitude: -70.87066371925623, difficulty: .intermediate), createAnnotation(title: "endGR", latitude: 44.469782541751115, longitude: -70.86966881640289, difficulty: .intermediate)]),
//19
        Trail(name: "Lower Downdraft", difficulty: "Intermediate", annotations: [createAnnotation(title: "LowerDowndraft", latitude: 44.46860992943861, longitude: -70.87879804629708, difficulty: .intermediate), createAnnotation(title: "GRJunctionLD", latitude: 44.46959736320973, longitude: -70.87530580117387, difficulty: .intermediate), createAnnotation(title: "AEJunctionLD", latitude: 44.46918178597036, longitude: -70.874023955678, difficulty: .intermediate)]),
//20
        Trail(name: "Dream Maker", difficulty: "Easy", annotations: [createAnnotation(title: "Dream Maker", latitude: 44.47041324409543, longitude: -70.87983797942842, difficulty: .easy), createAnnotation(title: "bend1DM", latitude: 44.47115946746551, longitude: -70.87910663287175, difficulty: .easy), createAnnotation(title: "TPJunctionDM", latitude: 44.47116183566172, longitude: -70.87818807321169, difficulty: .easy), createAnnotation(title: "Dream Maker", latitude: 44.47266041086979, longitude: -70.87677881029504, difficulty: .easy), createAnnotation(title: "Bend2DM", latitude: 44.47420077369788, longitude: -70.87533495049598, difficulty: .easy), createAnnotation(title: "Bend3DM", latitude: 44.47533196146996, longitude: -70.87194777471294, difficulty: .easy), createAnnotation(title: "Ridge Run Junction of Dream Maker", latitude: 44.47537671715984, longitude: -70.87087950264689, difficulty: .easy), createAnnotation(title: "T72JunctionDM", latitude: 44.47487871455419, longitude: -70.86698253348032, difficulty: .easy)]),
//21
        Trail(name: "T72", difficulty: "Terrain Park", annotations: [createAnnotation(title: "T72", latitude: 44.472471107753584, longitude: -70.87620738098036, difficulty: .terrainPark), createAnnotation(title: "lastMileJunctionT72", latitude: 44.47337872106561, longitude: -70.87490427324434, difficulty: .terrainPark), createAnnotation(title: "Ridge Run Junction of T72", latitude: 44.47453803470397, longitude: -70.87116281597753, difficulty: .terrainPark), createAnnotation(title: "endT72", latitude: 44.47473408882887, longitude: -70.86794362038924, difficulty: .terrainPark)]),
//22
        Trail(name: "Sensation", difficulty: "Easy", annotations: [createAnnotation(title: "Sensation", latitude: 44.47357411061319, longitude: -70.87714633484791, difficulty: .easy), createAnnotation(title: "bend1Sensation", latitude: 44.47383611957847, longitude: -70.87866777885614, difficulty: .easy), createAnnotation(title: "bend2Sensation", latitude: 44.473345120391464, longitude: -70.88219792471021, difficulty: .easy), createAnnotation(title: "bend3Sensation", latitude: 44.47295085342931, longitude: -70.88307854077962, difficulty: .easy), createAnnotation(title: "QLJunctionSensation", latitude: 44.47142563657733, longitude: -70.88504385707459, difficulty: .easy)]),
//23
        Trail(name: "Dream Maker Terrain Park", difficulty: "Terrain Park", annotations: [createAnnotation(title: "Dream Maker Terrain Park", latitude: 44.471098472385926, longitude: -70.87821486957192, difficulty: .terrainPark), createAnnotation(title: "botDMTP", latitude: 44.47093461371656, longitude: -70.87731104843927, difficulty: .terrainPark)]),
//24
        Trail(name: "Escapade", difficulty: "Intermediate", annotations: [createAnnotation(title: "Escapade", latitude: 44.470882935117665, longitude: -70.87588241388997, difficulty: .intermediate), createAnnotation(title: "bend1Escapade", latitude: 44.47042148619526, longitude: -70.87252464845587, difficulty: .intermediate), createAnnotation(title: "LMJunctionEscapade", latitude: 44.47141532781848, longitude: -70.87013850162772, difficulty: .intermediate)]),
//25
        Trail(name: "3D", difficulty: "Terrain Park", annotations: [createAnnotation(title: "3D", latitude: 44.47198060772869, longitude: -70.87525217806382, difficulty: .terrainPark), createAnnotation(title: "Last Mile Junction of 3D", latitude: 44.47277555409285, longitude: -70.87325638692266, difficulty: .terrainPark), createAnnotation(title: "Ridge Run Junction of 3D", latitude: 44.47357813833369, longitude: -70.87069873813503, difficulty: .terrainPark), createAnnotation(title: "bend13D", latitude: 44.47391397246592, longitude: -70.86865469996928, difficulty: .intermediate), createAnnotation(title: "bot3D", latitude: 44.474622082181334, longitude: -70.86708734917693, difficulty: .terrainPark)])]
    
//Spruce
    static let botSpruce = Vertex<ImageAnnotation>(Lifts[6].annotations[0])
    static let topSpruce = Vertex<ImageAnnotation>(Lifts[6].annotations[1])
//QLT
    static let botQLT = Vertex<ImageAnnotation>(Lifts[5].annotations[0])
    static let topQLT = Vertex<ImageAnnotation>(Lifts[5].annotations[1])
//North peak
    static let botNP = Vertex<ImageAnnotation>(Lifts[4].annotations[0])
    static let topNP = Vertex<ImageAnnotation>(Lifts[4].annotations[1])
//chondola
    static let botChondola = Vertex<ImageAnnotation>(Lifts[3].annotations[0])
    static let topChondola = Vertex<ImageAnnotation>(Lifts[3].annotations[1])
//Jordan DOuble
    static let auroraSideJD = Vertex<ImageAnnotation>(Lifts[2].annotations[0])
    static let jordanSideJD = Vertex<ImageAnnotation>(Lifts[2].annotations[1])
//aurora
    static let botAurora = Vertex<ImageAnnotation>(Lifts[1].annotations[0])
    static let topAurora = Vertex<ImageAnnotation>(Lifts[1].annotations[1])
//jordan
    static let topJord = Vertex<ImageAnnotation>(Lifts[0].annotations[1])
    static let botJord = Vertex<ImageAnnotation>(Lifts[0].annotations[0])
//lolapalooza
    static let topLol = Vertex<ImageAnnotation>(jordanTrails[0].annotations[0])
    static let bend1Lol = Vertex<ImageAnnotation>(jordanTrails[0].annotations[1])
    static let bend2Lol = Vertex<ImageAnnotation>(jordanTrails[0].annotations[2])
//excalibur
    static let topExcal = Vertex<ImageAnnotation>(jordanTrails[1].annotations[0])
    static let bend1Excal = Vertex<ImageAnnotation>(jordanTrails[1].annotations[1])
    static let midExcal = Vertex<ImageAnnotation>(jordanTrails[1].annotations[2])
    static let botExcal = Vertex<ImageAnnotation>(jordanTrails[1].annotations[3])
//rogueangel
    static let topRogue = Vertex<ImageAnnotation>(jordanTrails[2].annotations[0])
    static let midRogue = Vertex<ImageAnnotation>(jordanTrails[2].annotations[1])
    static let botRogue = Vertex<ImageAnnotation>(jordanTrails[2].annotations[2])
//icaramba
    static let topCaram = Vertex<ImageAnnotation>(jordanTrails[3].annotations[0])
    static let botCaram = Vertex<ImageAnnotation>(jordanTrails[3].annotations[1])
//kansas
    static let topKans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[0])
    static let bend1Kans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[1])
    static let ozJunctionKans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[2])
    static let woodsmanJunctionKans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[3])
    static let bend2Kans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[4])
    static let bend3Kans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[5])
    static let bend4Kans = Vertex<ImageAnnotation>( jordanTrails[4].annotations[6])
    static let endKans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[7])
    
//tin woodsman
    static let topWoodsman = Vertex<ImageAnnotation>(OzTrails[0].annotations[0])
    static let junctionWoodsman = Vertex<ImageAnnotation>(OzTrails[0].annotations[1])
    static let endWoodsman = Vertex<ImageAnnotation>(OzTrails[0].annotations[2])
    
//cyclone
    static let topCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[0])
    static let northernLightsJunctionCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[1])
    static let poppyFieldsJunctionCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[2])
    static let woodsmanJunctionCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[3])
    static let carambaJunctionCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[4])
    static let rogueAngelJunctionCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[5])
//northernlights
    static let northernLightsTop = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[0])
    static let witchWayJunctionNL = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[1])
    static let kansasNLJunction = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[2])
    static let cycloneJunctionNL = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[3])
    static let bend1NL = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[4])
    static let fireStarJunctionNL = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[5])
//witchway
    static let witchWayTop = Vertex<ImageAnnotation>(AuroraTrails[2].annotations[0])
    static let kansJunctionWitchWay = Vertex<ImageAnnotation>(AuroraTrails[2].annotations[1])
//airglow
    static let topAirglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[0])
    static let cycloneJunctionAirglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[1])
    static let bend1Airglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[2])
    static let blackHoleJunctionAirglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[3])
    static let bend2Airglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[4])
    static let botAirglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[5])
//blackhole
    static let topBlackHole = Vertex<ImageAnnotation>(AuroraTrails[4].annotations[0])
    static let botBlackHole = Vertex<ImageAnnotation>(AuroraTrails[4].annotations[1])
//firestar
    static let topFirestar = Vertex<ImageAnnotation>(AuroraTrails[5].annotations[0])
    static let bend1Firestar = Vertex<ImageAnnotation>(AuroraTrails[5].annotations[1])
    static let bend2Firestar = Vertex<ImageAnnotation>(AuroraTrails[5].annotations[2])
    static let endFirestar = Vertex<ImageAnnotation>(AuroraTrails[5].annotations[3])
//lights out
    static let startLO = Vertex<ImageAnnotation>(AuroraTrails[6].annotations[0])
    static let vortexJunctionLO = Vertex<ImageAnnotation>(AuroraTrails[6].annotations[1])
    static let UpperDownDraftJunctionLO = Vertex<ImageAnnotation>(AuroraTrails[6].annotations[2])
    static let endLightsOut = Vertex<ImageAnnotation>(AuroraTrails[6].annotations[3])
//borealis
    static let topBorealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[0])
    static let bend1Borealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[1])
    static let bend2Borealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[2])
    static let vortexJunctionBorealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[3])
    static let bend3Borealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[4])
    static let endBorealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[5])
//vortex
    static let topVortex = Vertex<ImageAnnotation>(AuroraTrails[8].annotations[0])
    static let kansasJunctionVortex = Vertex<ImageAnnotation>(AuroraTrails[8].annotations[1])
    static let botVortex = Vertex<ImageAnnotation>(AuroraTrails[8].annotations[2])
    
//paradigm
    static let topParadigm = Vertex<ImageAnnotation>(NorthPeakTrails[0].annotations[0])
    static let bend1Paradigm = Vertex<ImageAnnotation>(NorthPeakTrails[0].annotations[1])
    static let vortexJunctionParadigm = Vertex<ImageAnnotation>(NorthPeakTrails[0].annotations[2])
    static let botParadigm = Vertex<ImageAnnotation>(NorthPeakTrails[0].annotations[3])
//second mile
    static let startSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[0])
    static let GRJunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[1])
    static let DMTerrainJunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[2])
    static let escapadeJunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[3])
    static let ThreeDJunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[4])
    static let T72JunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[5])
    static let DMJunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[6])
    static let endSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[7])
//quantum leap
    static let topQuantum = Vertex<ImageAnnotation>(NorthPeakTrails[2].annotations[0])
    static let backsideJunctionQL = Vertex<ImageAnnotation>(NorthPeakTrails[2].annotations[1])
    static let bend1QL = Vertex<ImageAnnotation>(NorthPeakTrails[2].annotations[2])
    static let botQuantum = Vertex<ImageAnnotation>(NorthPeakTrails[2].annotations[3])
//Grand rapids
    static let topGR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[0])
    static let SMJunctionGR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[1])
    static let bend1GR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[2])
    static let downdraftJunctionGR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[3])
    static let bend2GR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[4])
    static let bend3GR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[5])
    static let lazyRiverJunctionGR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[6])
    static let endGR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[7])
//lower downdraft
    static let topLD = Vertex<ImageAnnotation>(NorthPeakTrails[4].annotations[0])
    static let GRJunctionLD = Vertex<ImageAnnotation>(NorthPeakTrails[4].annotations[1])
    static let AEJunctionLD = Vertex<ImageAnnotation>(NorthPeakTrails[4].annotations[2])
//dream maker
    static let topDM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[0])
    static let bend1DM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[1])
    static let TPJunctionDM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[2])
    static let Bend2DM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[3])
    static let Bend3DM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[4])
    static let RRJunctionDM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[5])
    static let T72JunctionDM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[7])
//t72
    static let topT72 = Vertex<ImageAnnotation>(NorthPeakTrails[6].annotations[0])
    static let lastMileJunctionT72 = Vertex<ImageAnnotation>(NorthPeakTrails[6].annotations[1])
    static let RRJunctionT72 = Vertex<ImageAnnotation>(NorthPeakTrails[6].annotations[2])
    static let endT72 = Vertex<ImageAnnotation>(NorthPeakTrails[6].annotations[3])
//sensation
    static let topSensation = Vertex<ImageAnnotation>(NorthPeakTrails[7].annotations[0])
    static let bend1Sensation = Vertex<ImageAnnotation>(NorthPeakTrails[7].annotations[1])
    static let bend2Sensation = Vertex<ImageAnnotation>(NorthPeakTrails[7].annotations[2])
    static let bend3Sensation = Vertex<ImageAnnotation>(NorthPeakTrails[7].annotations[3])
    static let QLJunctionSensation = Vertex<ImageAnnotation>(NorthPeakTrails[7].annotations[4])
//dream maker terrain park
    static let topDMTP = Vertex<ImageAnnotation>(NorthPeakTrails[8].annotations[0])
    static let botDMTP = Vertex<ImageAnnotation>(NorthPeakTrails[8].annotations[1])
//escapade
    static let topEscapade = Vertex<ImageAnnotation>(NorthPeakTrails[9].annotations[0])
    static let bend1Escapade = Vertex<ImageAnnotation>(NorthPeakTrails[9].annotations[1])
    static let LMJunctionEscapade = Vertex<ImageAnnotation>(NorthPeakTrails[9].annotations[2])
//3D
    static let top3D = Vertex<ImageAnnotation>(NorthPeakTrails[10].annotations[0])
    static let LMJunction3D = Vertex<ImageAnnotation>(NorthPeakTrails[10].annotations[1])
    static let RRJunction3D = Vertex<ImageAnnotation>(NorthPeakTrails[10].annotations[2])
    static let bend13D = Vertex<ImageAnnotation>(NorthPeakTrails[10].annotations[3])
    static let bot3D = Vertex<ImageAnnotation>(NorthPeakTrails[10].annotations[4])
//Barker
    static let botBarker = Vertex<ImageAnnotation>(Lifts[8].annotations[0])
    static let topBarker = Vertex<ImageAnnotation>(Lifts[8].annotations[1])
//Three Mile Trail
    static let start3ML = Vertex<ImageAnnotation>(barkerTrails[0].annotations[0])
    static let bend13ML = Vertex<ImageAnnotation>(barkerTrails[0].annotations[1])
    static let bend23ML = Vertex<ImageAnnotation>(barkerTrails[0].annotations[2])
    static let sluiceJunction3ML = Vertex<ImageAnnotation>(barkerTrails[0].annotations[3])
    static let gnarniaJunction3ML = Vertex<ImageAnnotation>(barkerTrails[0].annotations[4])
    static let RBJunction3ML = Vertex<ImageAnnotation>(barkerTrails[0].annotations[5])
    static let AEJunction3ML = Vertex<ImageAnnotation>(barkerTrails[0].annotations[6])
    static let bend33ML = Vertex<ImageAnnotation>(barkerTrails[0].annotations[7])
    static let end3ML = Vertex<ImageAnnotation>(barkerTrails[0].annotations[8])
// Lazy River
    static let startLR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[0])
    static let bend1LR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[1])
    static let ThreeMLJunctionLR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[2])
    static let bend2LR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[3])
    static let bend3LR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[4])
    static let bend4LR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[5])
    static let sluiceJunctionLR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[6])
    static let gnarniaJunctionLR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[7])
    static let RBJunctionLR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[8])
    static let bend5LR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[9])
    static let AEJunctionLR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[10])
    static let GRJunctionLR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[11])
    static let endLR = Vertex<ImageAnnotation>(barkerTrails[1].annotations[12])
// Sluice
    static let startSluice = Vertex<ImageAnnotation>(barkerTrails[2].annotations[0])
    static let bend1Sluice = Vertex<ImageAnnotation>(barkerTrails[2].annotations[1])
    static let endSluice = Vertex<ImageAnnotation>(barkerTrails[2].annotations[2])
//Right Stuff
    static let topRS = Vertex<ImageAnnotation>(barkerTrails[3].annotations[0])
    static let bend1RS = Vertex<ImageAnnotation>(barkerTrails[3].annotations[1])
    static let bend2RS = Vertex<ImageAnnotation>(barkerTrails[3].annotations[2])
    static let bend3RS = Vertex<ImageAnnotation>(barkerTrails[3].annotations[3])
    static let LSPJunctionRS = Vertex<ImageAnnotation>(barkerTrails[3].annotations[4])
//Agony
    static let topAgony = Vertex<ImageAnnotation>(barkerTrails[4].annotations[0])
    static let TGJunctionAgony = Vertex<ImageAnnotation>(barkerTrails[4].annotations[1])
    static let endAgony = Vertex<ImageAnnotation>(barkerTrails[4].annotations[2])
//Top Gun
    static let topTG = Vertex<ImageAnnotation>(barkerTrails[5].annotations[0])
    static let bend1TG = Vertex<ImageAnnotation>(barkerTrails[5].annotations[1])
    static let LSPJunctionTG = Vertex<ImageAnnotation>(barkerTrails[5].annotations[2])
//Ecstasy
    static let topEcstasy = Vertex<ImageAnnotation>(barkerTrails[6].annotations[0])
    static let bend1Ecstasy = Vertex<ImageAnnotation>(barkerTrails[6].annotations[1])
    static let bend2Ecstasy = Vertex<ImageAnnotation>(barkerTrails[6].annotations[2])
    static let southPawEcstasy = Vertex<ImageAnnotation>(barkerTrails[6].annotations[3])
    static let uppercutJunctionEcstasy = Vertex<ImageAnnotation>(barkerTrails[6].annotations[4])
// Jungle Road
    static let startJR = Vertex<ImageAnnotation>(barkerTrails[7].annotations[0])
    static let bend1JR = Vertex<ImageAnnotation>(barkerTrails[7].annotations[1])
    static let bend2JR = Vertex<ImageAnnotation>(barkerTrails[7].annotations[2])
    static let GPJunctionJR = Vertex<ImageAnnotation>(barkerTrails[7].annotations[3])
    static let USPJunctionJR = Vertex<ImageAnnotation>(barkerTrails[7].annotations[4])
// Lower Upper Cut
    static let topLUC = Vertex<ImageAnnotation>(barkerTrails[8].annotations[0])
    static let botLUC = Vertex<ImageAnnotation>(barkerTrails[8].annotations[1])
//South Paw
    static let topSP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[0])
    static let splitSP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[1])
    static let LSPJunctionSP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[2])
    static let bend1SP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[3])
    static let bend2SP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[4])
    static let bend3SP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[5])
    static let agonyJunctionSP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[6])
    static let LSP2JunctionSP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[7])
// Lower Sunday Punch
    static let topLSP = Vertex<ImageAnnotation>(barkerTrails[10].annotations[0])
    static let SPJunctionuLSP = Vertex<ImageAnnotation>(barkerTrails[10].annotations[1])
    static let bend1LSP = Vertex<ImageAnnotation>(barkerTrails[10].annotations[2])
    static let SPRCJunctionLSP = Vertex<ImageAnnotation>(barkerTrails[10].annotations[3])
    static let TGJunctionLSP = Vertex<ImageAnnotation>(barkerTrails[10].annotations[4])
    static let RSJunctionLSP = Vertex<ImageAnnotation>(barkerTrails[10].annotations[5])
    static let TTJunctionLSP = Vertex<ImageAnnotation>(barkerTrails[10].annotations[6])
    static let endLSP = Vertex<ImageAnnotation>(barkerTrails[10].annotations[7])
//Rocking Chair
    static let topRC = Vertex<ImageAnnotation>(barkerTrails[11].annotations[0])
    static let bend1RC = Vertex<ImageAnnotation>(barkerTrails[11].annotations[1])
    static let endRC = Vertex<ImageAnnotation>(barkerTrails[11].annotations[2])
//Tightwire
    static let topTW = Vertex<ImageAnnotation>(barkerTrails[12].annotations[0])
    static let bend1TW = Vertex<ImageAnnotation>(barkerTrails[12].annotations[1])
    static let RCJunctionTW = Vertex<ImageAnnotation>(barkerTrails[12].annotations[2])
//Southridge
    static let botSouthridge = Vertex<ImageAnnotation>(Lifts[7].annotations[0])
    static let topSouthridge = Vertex<ImageAnnotation>(Lifts[7].annotations[1])
//Ridge Run
    static let startRR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[0])
    static let EFJunctionRR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[1])
    static let TDJunctionRR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[2])
    static let bend1RR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[3])
    static let T72JunctionRR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[4])
    static let DMJunctionRR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[5])
    static let LCJunctionRR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[6])
    static let STJunctionRR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[7])
    static let bend2RR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[8])
    static let bend3RR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[9])
    static let bend4RR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[10])
    static let bend5RR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[11])
    static let bend6RR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[12])
    static let endRR = Vertex<ImageAnnotation>(southRidgeTrails[0].annotations[13])
//Lower Escapade
    static let topLE = Vertex<ImageAnnotation>(southRidgeTrails[1].annotations[0])
    static let broadwayJunctionLE = Vertex<ImageAnnotation>(southRidgeTrails[1].annotations[1])
    static let NWJunctionLE = Vertex<ImageAnnotation>(southRidgeTrails[1].annotations[2])
    static let endLE = Vertex<ImageAnnotation>(southRidgeTrails[1].annotations[3])
//Broadway
    static let topBroadway = Vertex<ImageAnnotation>(southRidgeTrails[2].annotations[0])
    static let NWJunctionBroadway = Vertex<ImageAnnotation>(southRidgeTrails[2].annotations[1])
    static let MBJunctionBroadway = Vertex<ImageAnnotation>(southRidgeTrails[2].annotations[2])
    static let WVJunctionBroadway = Vertex<ImageAnnotation>(southRidgeTrails[2].annotations[3])
    static let WLJunctionBroadway = Vertex<ImageAnnotation>(southRidgeTrails[2].annotations[4])
    static let endBroadway = Vertex<ImageAnnotation>(southRidgeTrails[2].annotations[5])
//Lower Lazy River
    static let topLLR = Vertex<ImageAnnotation>(southRidgeTrails[3].annotations[0])
    static let bend1LLR = Vertex<ImageAnnotation>(southRidgeTrails[3].annotations[1])
    static let broadwayJunctionLLR = Vertex<ImageAnnotation>(southRidgeTrails[3].annotations[2])
    static let endLLR = Vertex<ImageAnnotation>(southRidgeTrails[3].annotations[3])
//Thataway
    static let startThataway = Vertex<ImageAnnotation>(southRidgeTrails[4].annotations[0])
    static let endThataway = Vertex<ImageAnnotation>(southRidgeTrails[4].annotations[1])
//Mixing Bowl
    static let topMB = Vertex<ImageAnnotation>(southRidgeTrails[5].annotations[0])
    static let bend1MB = Vertex<ImageAnnotation>(southRidgeTrails[5].annotations[1])
    static let endMB = Vertex<ImageAnnotation>(southRidgeTrails[5].annotations[2])
//Lower Chondi Line
    static let topLCL = Vertex<ImageAnnotation>(southRidgeTrails[6].annotations[0])
    static let endLCL = Vertex<ImageAnnotation>(southRidgeTrails[6].annotations[1])
//Who ville
    static let topWV = Vertex<ImageAnnotation>(southRidgeTrails[7].annotations[0])
    static let endWV = Vertex<ImageAnnotation>(southRidgeTrails[7].annotations[1])
//Wonderland
    static let topWL = Vertex<ImageAnnotation>(southRidgeTrails[8].annotations[0])
    static let endWL = Vertex<ImageAnnotation>(southRidgeTrails[8].annotations[1])
//Northway
    static let topNW = Vertex<ImageAnnotation>(southRidgeTrails[9].annotations[0])
    static let LEJunctionNW = Vertex<ImageAnnotation>(southRidgeTrails[9].annotations[1])
    static let EFJunctionNW = Vertex<ImageAnnotation>(southRidgeTrails[9].annotations[2])
    static let endNW = Vertex<ImageAnnotation>(southRidgeTrails[9].annotations[3])
//Spectator
    static let topSpectator = Vertex<ImageAnnotation>(southRidgeTrails[10].annotations[0])
    static let sundanceJunctionSpectator = Vertex<ImageAnnotation>(southRidgeTrails[10].annotations[1])
    static let endSpectator = Vertex<ImageAnnotation>(southRidgeTrails[10].annotations[2])
//Double Dipper
    static let topDD = Vertex<ImageAnnotation>(southRidgeTrails[11].annotations[0])
    static let DMJunctionDD = Vertex<ImageAnnotation>(southRidgeTrails[11].annotations[1])
    static let endDD = Vertex<ImageAnnotation>(southRidgeTrails[11].annotations[2])
//Sundance
    static let topSD = Vertex<ImageAnnotation>(southRidgeTrails[12].annotations[0])
    static let DDSPRJunctionSD = Vertex<ImageAnnotation>(southRidgeTrails[12].annotations[1])
    static let DMJunctionSD = Vertex<ImageAnnotation>(southRidgeTrails[12].annotations[2])
    static let bend1SD = Vertex<ImageAnnotation>(southRidgeTrails[12].annotations[3])
    static let botSD = Vertex<ImageAnnotation>(southRidgeTrails[12].annotations[4])
//second thoughts
    static let topST = Vertex<ImageAnnotation>(southRidgeTrails[13].annotations[0])
    static let bend1ST = Vertex<ImageAnnotation>(southRidgeTrails[13].annotations[1])
    static let endST = Vertex<ImageAnnotation>(southRidgeTrails[13].annotations[2])
//Exit Right
    static let topER = Vertex<ImageAnnotation>(southRidgeTrails[14].annotations[0])
    static let endER = Vertex<ImageAnnotation>(southRidgeTrails[14].annotations[1])
//Exit Left
    static let topEL = Vertex<ImageAnnotation>(southRidgeTrails[15].annotations[0])
    static let endEL = Vertex<ImageAnnotation>(southRidgeTrails[15].annotations[1])
//Sirius
    static let topSirius = Vertex<ImageAnnotation>(spruceTrails[0].annotations[0])
    static let endSirius = Vertex<ImageAnnotation>(spruceTrails[0].annotations[1])
// Upper Downdraft
    static let topDowndraft = Vertex<ImageAnnotation>(spruceTrails[1].annotations[0])
    static let endDowndraft = Vertex<ImageAnnotation>(spruceTrails[1].annotations[1])
//American Express
    static let topAE = Vertex<ImageAnnotation>(spruceTrails[2].annotations[0])
    static let TMLJunctionAE = Vertex<ImageAnnotation>(spruceTrails[2].annotations[1])
    static let bend1AE = Vertex<ImageAnnotation>(spruceTrails[2].annotations[2])
    static let LRJunctionAE = Vertex<ImageAnnotation>(spruceTrails[2].annotations[3])
//Risky Business
    static let topRB = Vertex<ImageAnnotation>(spruceTrails[3].annotations[0])
    static let bend1RB = Vertex<ImageAnnotation>(spruceTrails[3].annotations[1])
    static let bend2RB = Vertex<ImageAnnotation>(spruceTrails[3].annotations[2])
    static let LRJunctionRB = Vertex<ImageAnnotation>(spruceTrails[3].annotations[3])
//Gnarnia
    static let topGnarnia = Vertex<ImageAnnotation>(spruceTrails[4].annotations[0])
    static let TMLJunctionGnarnia = Vertex<ImageAnnotation>(spruceTrails[4].annotations[1])
    static let endGnarnia = Vertex<ImageAnnotation>(spruceTrails[4].annotations[2])
//Tourist Trap
    static let topTT = Vertex<ImageAnnotation>(spruceTrails[5].annotations[0])
    static let OHJunctionTT = Vertex<ImageAnnotation>(spruceTrails[5].annotations[1])
    static let endTT = Vertex<ImageAnnotation>(spruceTrails[5].annotations[2])

    static let keyAnnotations = [botSpruce, botQLT, botNP, botChondola, auroraSideJD, jordanSideJD, botAurora, botJord, topLol, topExcal, topRogue, topCaram, topKans, junctionWoodsman, topCyclone, northernLightsJunctionCyclone, kansasNLJunction, witchWayTop, cycloneJunctionAirglow, topBlackHole, topFirestar, startLO, topBorealis, kansasJunctionVortex, topParadigm, startSM, SMJunctionGR, topQuantum, topGR, topLD, topDM, Bend2DM, topT72, topSensation, topDMTP, topEscapade, top3D, botBarker, start3ML, startLR, startSluice, topRS, topAgony, topTG, topEcstasy, startJR, topLUC, topSP, topLSP, topRC, topTW, botSouthridge, startRR, topLE, topBroadway, topLLR, startThataway, topMB, topLCL, topWV, topWL, topNW, topSpectator, topDD, topSD, topST, topER, topEL, topSirius, topDowndraft, topAE, topRB, topGnarnia, topTT]
    
    static let jordanKeyAnnotations = [botJord, topLol, topRogue, topExcal, topCaram, jordanSideJD]
    
    static let auroraKeyAnnotations = [botAurora, botQLT, topBorealis, topCyclone, northernLightsJunctionCyclone, kansasNLJunction, kansasJunctionVortex, startLO, topFirestar, topBlackHole, cycloneJunctionAirglow, witchWayTop]
    
    static let northPeakKeyAnnotations = [botNP, topParadigm, startSM, topEscapade, top3D, topSensation, topDM, topLD, topGR, topQuantum]
    
    static let barkerKeyAnnotations = [botBarker, start3ML, startLR, startSluice, topRS, topAgony, topTG, topEcstasy, startJR, topLUC, topSP, topLSP, topRC, topTW]
    
    static let southRidgeKeyAnnotations = [botSouthridge, botChondola, startRR, topLE, topBroadway, topLLR, startThataway, topMB, topLCL, topWV, topWL, topNW, topSpectator, topDD, topSD, topST, topER, topEL]
    
    static let spruceKeyAnnotations = [botSpruce, topSirius, topDowndraft, topAE, topRB, topGnarnia, topTT]
    
    static let clusterKeyAnnotations = [jordanKeyAnnotations, auroraKeyAnnotations, northPeakKeyAnnotations, barkerKeyAnnotations, southRidgeKeyAnnotations, spruceKeyAnnotations]
    
    static let annotations = [botSpruce, topSpruce, botQLT, topQLT, botNP, topNP, botChondola, topChondola, auroraSideJD, jordanSideJD, botAurora, topAurora, botJord, topJord, topLol, bend1Lol, bend2Lol, topExcal, bend1Excal, midExcal, botExcal, topRogue, midRogue, botRogue, topCaram, botCaram, topKans, bend1Kans, ozJunctionKans, woodsmanJunctionKans, bend2Kans, bend3Kans, bend4Kans, endKans, topWoodsman, junctionWoodsman, endWoodsman, topCyclone, northernLightsJunctionCyclone, poppyFieldsJunctionCyclone, woodsmanJunctionCyclone, carambaJunctionCyclone, rogueAngelJunctionCyclone, northernLightsTop, witchWayJunctionNL, kansasNLJunction, cycloneJunctionNL, bend1NL, fireStarJunctionNL, witchWayTop, kansJunctionWitchWay, topAirglow, cycloneJunctionAirglow, bend1Airglow, blackHoleJunctionAirglow, bend2Airglow, botAirglow, topBlackHole, botBlackHole, topFirestar, bend1Firestar, bend2Firestar, endFirestar, topBorealis, bend1Borealis, bend2Borealis, vortexJunctionBorealis,bend3Borealis, endBorealis, topVortex, kansasJunctionVortex, botVortex, topParadigm, bend1Paradigm, vortexJunctionParadigm, botParadigm, startSM, GRJunctionSM, DMTerrainJunctionSM, escapadeJunctionSM, ThreeDJunctionSM, T72JunctionSM, DMJunctionSM, endSM, topQuantum, backsideJunctionQL, bend1QL, botQuantum, topGR, SMJunctionGR, bend1GR, downdraftJunctionGR, bend2GR, bend3GR, lazyRiverJunctionGR, endGR, topLD, GRJunctionLD, AEJunctionLD, topDM, bend1DM, TPJunctionDM, Bend2DM, Bend3DM, RRJunctionDM, T72JunctionDM, topT72, lastMileJunctionT72, RRJunctionT72, endT72, topSensation, bend1Sensation, bend2Sensation, bend3Sensation, QLJunctionSensation, topDMTP, botDMTP, topEscapade, bend1Escapade, LMJunctionEscapade, top3D, LMJunction3D, RRJunction3D, bend13D, bot3D, startLO, vortexJunctionLO, UpperDownDraftJunctionLO, endLightsOut, botBarker, topBarker, start3ML, bend13ML, sluiceJunction3ML, gnarniaJunction3ML, RBJunction3ML, AEJunction3ML, bend23ML, bend33ML, end3ML, startLR, bend1LR, ThreeMLJunctionLR, bend2LR, bend3LR, bend4LR, sluiceJunctionLR, gnarniaJunctionLR, RBJunctionLR, bend5LR, AEJunctionLR, GRJunctionLR, endLR, startSluice, bend1Sluice, endSluice, topRS, bend1RS, bend2RS, bend3RS, LSPJunctionRS, topAgony, TGJunctionAgony, endAgony, topTG, bend1TG, LSPJunctionTG, topEcstasy, bend1Ecstasy, bend2Ecstasy, southPawEcstasy, uppercutJunctionEcstasy, startJR, bend1JR, bend2JR, GPJunctionJR, USPJunctionJR, topSP, splitSP, LSPJunctionSP, bend1SP, bend2SP, bend3SP, agonyJunctionSP, LSP2JunctionSP, topLSP, SPJunctionuLSP, bend1LSP, SPRCJunctionLSP, TGJunctionLSP, RSJunctionLSP, TTJunctionLSP, endLSP, topRC, bend1RC, endRC, topTW, bend1TW, RCJunctionTW, botSouthridge, topSouthridge, startRR, EFJunctionRR, TDJunctionRR, bend1RR, T72JunctionRR, DMJunctionRR, STJunctionRR, LCJunctionRR, bend2RR, bend3RR, bend4RR, bend5RR, bend6RR, endRR, topLE, broadwayJunctionLE, NWJunctionLE, endLE, topBroadway, NWJunctionBroadway, MBJunctionBroadway, WVJunctionBroadway, WLJunctionBroadway, endBroadway, topLLR, bend1LLR, broadwayJunctionLLR, endLLR, startThataway, endThataway, topMB, bend1MB, endMB, topLCL, endLCL, topWV, endWV, topWL, endWL, topNW, LEJunctionNW, EFJunctionNW, endNW, topSpectator, sundanceJunctionSpectator, endSpectator, topDD, DMJunctionDD, endDD, topSD, DDSPRJunctionSD, DMJunctionSD, bend1SD, botSD, topST, bend1ST, endST, topER, endER, topEL, endEL, topSirius, endSirius, topDowndraft, endDowndraft, topAE, TMLJunctionAE, bend1AE, LRJunctionAE, topRB, bend1RB, bend2RB, LRJunctionRB, topGnarnia, TMLJunctionGnarnia, endGnarnia, topTT, OHJunctionTT, endTT]
    
    static let graph = EdgeWeightedDigraph<ImageAnnotation>()
    
    static func addVertexes(){
        for vertex in annotations{
            graph.addVertex(vertex)
        }
    }
    static func createEdges()
    {
//Jordan
        graph.addEdge(direction: .undirected, from: jordanSideJD, to: botJord, weight: 100)
        graph.addEdge(direction: .directed, from: botJord, to: topJord, weight: 100)
//lollapalooza
        graph.addEdge(direction: .undirected, from: topJord, to: topLol, weight: 1)
        graph.addEdge(direction: .directed, from: topLol, to: bend1Lol, weight: 1)
        graph.addEdge(direction: .directed, from: bend1Lol, to: bend2Lol, weight: 1)
        graph.addEdge(direction: .directed, from: bend2Lol, to: botJord, weight: 1)
//excalibur
        graph.addEdge(direction: .directed, from: topLol, to: topExcal, weight: 1)
        graph.addEdge(direction: .directed, from: topExcal, to: bend1Excal, weight: 50)
        graph.addEdge(direction: .directed, from: bend1Excal, to: midExcal, weight: 50)
        graph.addEdge(direction: .directed, from: midExcal, to: botExcal, weight: 50)
        graph.addEdge(direction: .directed, from: botExcal, to: botJord, weight: 50)
//rogue
        graph.addEdge(direction: .undirected, from: topJord, to: topRogue, weight: 1)
        graph.addEdge(direction: .directed, from: topRogue, to: midRogue, weight: 50)
        graph.addEdge(direction: .directed, from: topRogue, to: topCaram, weight: 50)
        graph.addEdge(direction: .directed, from: midRogue, to: botRogue, weight: 50)
        graph.addEdge(direction: .directed, from: botRogue, to: rogueAngelJunctionCyclone, weight: 50)
//iCaramba
        graph.addEdge(direction: .directed, from: topCaram, to: botCaram, weight: 4000)
        graph.addEdge(direction: .directed, from: botCaram, to: carambaJunctionCyclone, weight: 4000)
//kansas
        graph.addEdge(direction: .undirected, from: topJord, to: topKans, weight: 1)
        graph.addEdge(direction: .directed, from: topKans, to: bend1Kans, weight: 1)
        graph.addEdge(direction: .directed, from: bend1Kans, to: ozJunctionKans, weight: 1)
        graph.addEdge(direction: .directed, from: ozJunctionKans, to: woodsmanJunctionKans, weight: 1)
        graph.addEdge(direction: .undirected, from: junctionWoodsman, to: woodsmanJunctionKans, weight: 1)
        graph.addEdge(direction: .directed, from: woodsmanJunctionKans, to: bend2Kans, weight: 1)
        graph.addEdge(direction: .directed, from: bend2Kans, to: bend3Kans, weight: 1)
        graph.addEdge(direction: .directed, from: bend3Kans, to: bend4Kans, weight: 1)
        graph.addEdge(direction: .directed, from: bend4Kans, to: kansJunctionWitchWay, weight: 1)
        graph.addEdge(direction: .directed, from: endKans, to: topCyclone, weight: 1)
        graph.addEdge(direction: .directed, from: endKans, to: northernLightsJunctionCyclone, weight: 1)
//woodsman
        graph.addEdge(direction: .directed, from: topWoodsman, to: junctionWoodsman, weight: 4000)
        graph.addEdge(direction: .undirected, from: woodsmanJunctionKans, to: junctionWoodsman, weight: 1)
        graph.addEdge(direction: .directed, from: junctionWoodsman, to: endWoodsman, weight: 4000)
        graph.addEdge(direction: .undirected, from: endWoodsman, to: woodsmanJunctionCyclone, weight: 4000)
//Cyclone
        graph.addEdge(direction: .directed, from: topCyclone, to: northernLightsJunctionCyclone, weight: 1)
        graph.addEdge(direction: .undirected, from: topCyclone, to: startLO, weight: 1)
        graph.addEdge(direction: .directed, from: northernLightsJunctionCyclone, to: poppyFieldsJunctionCyclone, weight: 1)
//                graph.addEdge(direction: .directed, from: northernLightsJunctionCyclone, to: bend1NL, weight: 1)
        graph.addEdge(direction: .directed, from: poppyFieldsJunctionCyclone, to: woodsmanJunctionCyclone, weight: 1)
        graph.addEdge(direction: .directed, from: woodsmanJunctionCyclone, to: carambaJunctionCyclone, weight: 1)
        graph.addEdge(direction: .directed, from: carambaJunctionCyclone, to: rogueAngelJunctionCyclone, weight: 1)
        graph.addEdge(direction: .directed, from: rogueAngelJunctionCyclone, to: botJord, weight: 1)
//Aurora
        graph.addEdge(direction: .directed, from: botAurora, to: topAurora, weight: 100)
        graph.addEdge(direction: .undirected, from: botAurora, to: auroraSideJD, weight: 1)
        graph.addEdge(direction: .undirected, from: botAurora, to: botQLT, weight: 1)
//Jordan double
        graph.addEdge(direction: .undirected, from: auroraSideJD, to: jordanSideJD, weight: 100)
//northernlights
        graph.addEdge(direction: .undirected, from: topAurora, to: northernLightsTop, weight: 50)
        graph.addEdge(direction: .directed, from: northernLightsTop, to: witchWayJunctionNL, weight: 50)
        graph.addEdge(direction: .undirected, from: witchWayJunctionNL, to: witchWayTop, weight: 50)
        graph.addEdge(direction: .directed, from: witchWayJunctionNL, to: kansasNLJunction, weight: 50)
        graph.addEdge(direction: .undirected, from: kansasNLJunction, to: topCyclone, weight: 50)
        graph.addEdge(direction: .directed, from: kansasNLJunction, to: cycloneJunctionNL, weight: 50)
        graph.addEdge(direction: .undirected, from: kansasNLJunction, to: endKans, weight: 50)
        graph.addEdge(direction: .undirected, from: cycloneJunctionNL, to: northernLightsJunctionCyclone, weight: 50)
        graph.addEdge(direction: .directed, from: cycloneJunctionNL, to: bend1NL, weight: 50)
        graph.addEdge(direction: .directed, from: bend1NL, to: fireStarJunctionNL, weight: 50)
        graph.addEdge(direction: .undirected, from: fireStarJunctionNL, to: topFirestar, weight: 50)
        graph.addEdge(direction: .directed, from: fireStarJunctionNL, to: botAurora, weight: 50)
//witchway
        graph.addEdge(direction: .directed, from: witchWayTop, to: kansJunctionWitchWay, weight: 50)
        graph.addEdge(direction: .directed, from: kansJunctionWitchWay, to: endKans, weight: 1)
//firestar
        graph.addEdge(direction: .directed, from: topFirestar, to: bend1Firestar, weight: 50)
        graph.addEdge(direction: .directed, from: bend1Firestar, to: bend2Firestar, weight: 50)
        graph.addEdge(direction: .directed, from: bend2Firestar, to: endFirestar, weight: 50)
        graph.addEdge(direction: .directed, from: endFirestar, to: botJord, weight: 50)
//Borealis
        graph.addEdge(direction: .undirected, from: topAurora, to: topBorealis, weight: 1)
        graph.addEdge(direction: .directed, from: topBorealis, to: bend1Borealis, weight: 1)
        graph.addEdge(direction: .directed, from: bend1Borealis, to: bend2Borealis, weight: 1)
        graph.addEdge(direction: .directed, from: bend2Borealis, to: vortexJunctionBorealis, weight: 1)
        graph.addEdge(direction: .undirected, from: vortexJunctionBorealis, to: topVortex, weight: 1)
        graph.addEdge(direction: .directed, from: vortexJunctionBorealis, to: bend3Borealis, weight: 1)
        graph.addEdge(direction: .directed, from: bend3Borealis, to: endBorealis, weight: 1)
        graph.addEdge(direction: .directed, from: endBorealis, to: startLO, weight: 1)
        graph.addEdge(direction: .directed, from: endBorealis, to: topCyclone, weight: 1)
//Vortex
        graph.addEdge(direction: .directed, from: topVortex, to: kansasJunctionVortex, weight: 4000)
        graph.addEdge(direction: .directed, from: kansasJunctionVortex, to: botVortex, weight: 4000)
        graph.addEdge(direction: .undirected, from: botVortex, to: vortexJunctionParadigm, weight: 4000)
//Airglow
        graph.addEdge(direction: .undirected, from: topAurora, to: topAirglow, weight: 300)
        graph.addEdge(direction: .directed, from: topAirglow, to: cycloneJunctionAirglow, weight: 300)
        graph.addEdge(direction: .undirected, from: cycloneJunctionAirglow, to: topCyclone, weight: 1)
        graph.addEdge(direction: .directed, from: cycloneJunctionAirglow, to: bend1Airglow, weight: 300)
        graph.addEdge(direction: .directed, from: bend1Airglow, to: blackHoleJunctionAirglow, weight: 300)
        graph.addEdge(direction: .undirected, from: blackHoleJunctionAirglow, to: topBlackHole, weight: 300)
        graph.addEdge(direction: .directed, from: blackHoleJunctionAirglow, to: bend2Airglow, weight: 300)
        graph.addEdge(direction: .directed, from: bend2Airglow, to: botAirglow, weight: 300)
        graph.addEdge(direction: .directed, from: botAirglow, to: botAurora, weight: 300)
//blackHole
        graph.addEdge(direction: .directed, from: topBlackHole, to: botBlackHole, weight: 4000)
        graph.addEdge(direction: .directed, from: botBlackHole, to: botAirglow, weight: 4000)
//LightsOut
        graph.addEdge(direction: .directed, from: startLO, to: vortexJunctionLO, weight: 1)
        graph.addEdge(direction: .undirected, from: vortexJunctionLO, to: kansasJunctionVortex, weight: 1)
        graph.addEdge(direction: .directed, from: vortexJunctionLO, to: UpperDownDraftJunctionLO, weight: 1)
        graph.addEdge(direction: .directed, from: UpperDownDraftJunctionLO, to: endLightsOut, weight: 1)
        graph.addEdge(direction: .directed, from: endLightsOut, to: topChondola, weight: 1)
//Chondola
        graph.addEdge(direction: .directed, from: botChondola, to: topChondola, weight: 100)
//North Peak Quad
        graph.addEdge(direction: .directed, from: botNP, to: topNP, weight: 100)
//paradigm
        graph.addEdge(direction: .undirected, from: topChondola, to: topParadigm, weight: 50)
        graph.addEdge(direction: .directed, from: topParadigm, to: bend1Paradigm, weight: 50)
        graph.addEdge(direction: .directed, from: bend1Paradigm, to: vortexJunctionParadigm, weight: 50)
        graph.addEdge(direction: .directed, from: vortexJunctionParadigm, to: botParadigm, weight: 50)
        graph.addEdge(direction: .directed, from: botParadigm, to: botAurora, weight: 50)
//secondMile
        graph.addEdge(direction: .directed, from: topChondola, to: startSM, weight: 1)
        graph.addEdge(direction: .directed, from: startSM, to: GRJunctionSM, weight: 1)
        graph.addEdge(direction: .undirected, from: GRJunctionSM, to: SMJunctionGR, weight: 1)
        graph.addEdge(direction: .directed, from: GRJunctionSM, to: DMTerrainJunctionSM, weight: 1)
        graph.addEdge(direction: .undirected, from: DMTerrainJunctionSM, to: botDMTP, weight: 1)
        graph.addEdge(direction: .directed, from: DMTerrainJunctionSM, to: escapadeJunctionSM, weight: 1)
        graph.addEdge(direction: .undirected, from: escapadeJunctionSM, to: topEscapade, weight: 1)
        graph.addEdge(direction: .directed, from: escapadeJunctionSM, to: ThreeDJunctionSM, weight: 1)
        graph.addEdge(direction: .undirected, from: ThreeDJunctionSM, to: top3D, weight: 1)
        graph.addEdge(direction: .directed, from: ThreeDJunctionSM, to: T72JunctionSM, weight: 1)
        graph.addEdge(direction: .undirected, from: T72JunctionSM, to: topT72, weight: 1)
        graph.addEdge(direction: .directed, from: T72JunctionSM, to: DMJunctionSM, weight: 1)
        graph.addEdge(direction: .undirected, from: DMJunctionSM, to: Bend2DM, weight: 1)
        graph.addEdge(direction: .directed, from: DMJunctionSM, to: endSM, weight: 1)
        graph.addEdge(direction: .directed, from: endSM, to: topSensation, weight: 1)
//grand rapids
        graph.addEdge(direction: .undirected, from: topNP, to: topGR, weight: 50)
        graph.addEdge(direction: .directed, from: topGR, to: SMJunctionGR, weight: 50)
        graph.addEdge(direction: .directed, from: SMJunctionGR, to: bend1GR, weight: 50)
        graph.addEdge(direction: .directed, from: bend1GR, to: downdraftJunctionGR, weight: 50)
        graph.addEdge(direction: .directed, from: downdraftJunctionGR, to: bend2GR, weight: 50)
        graph.addEdge(direction: .directed, from: bend2GR, to: bend3GR, weight: 50)
        graph.addEdge(direction: .directed, from: bend3GR, to: lazyRiverJunctionGR, weight: 50)
        graph.addEdge(direction: .directed, from: lazyRiverJunctionGR, to: endGR, weight: 50)
        graph.addEdge(direction: .directed, from: endGR, to: botSpruce, weight: 50)
//Dream Maker
        graph.addEdge(direction: .undirected, from: topNP, to: topDM, weight: 1)
        graph.addEdge(direction: .directed, from: topDM, to: bend1DM, weight: 1)
        graph.addEdge(direction: .directed, from: bend1DM, to: TPJunctionDM, weight: 1)
        graph.addEdge(direction: .undirected, from: TPJunctionDM, to: topDMTP, weight: 1)
        graph.addEdge(direction: .directed, from: TPJunctionDM, to: Bend2DM, weight: 1)
        graph.addEdge(direction: .directed, from: Bend2DM, to: Bend3DM, weight: 1)
        graph.addEdge(direction: .directed, from: Bend3DM, to: RRJunctionDM, weight: 1)
        graph.addEdge(direction: .directed, from: RRJunctionDM, to: DMJunctionRR, weight: 1)
        graph.addEdge(direction: .directed, from: DMJunctionRR, to: endST, weight: 1)
        graph.addEdge(direction: .directed, from: endST, to: T72JunctionDM, weight: 1)
        graph.addEdge(direction: .directed, from: T72JunctionDM, to: botNP, weight: 1)
//DMTP
        graph.addEdge(direction: .directed, from: topDMTP, to: botDMTP, weight: 1)
//Escapade
        graph.addEdge(direction: .directed, from: topEscapade, to: bend1Escapade, weight: 50)
        graph.addEdge(direction: .directed, from: bend1Escapade, to: LMJunctionEscapade, weight: 50)
//3D
        graph.addEdge(direction: .directed, from: top3D, to: LMJunction3D, weight: 50)
        graph.addEdge(direction: .directed, from: LMJunction3D, to: RRJunction3D, weight: 50)
        graph.addEdge(direction: .directed, from: RRJunction3D, to: bend13D, weight: 50)
        graph.addEdge(direction: .directed, from: bend13D, to: bot3D, weight: 50)
        graph.addEdge(direction: .directed, from: bot3D, to: T72JunctionDM, weight: 50)
//T72
        graph.addEdge(direction: .directed, from: topT72, to: lastMileJunctionT72, weight: 50)
        graph.addEdge(direction: .directed, from: lastMileJunctionT72, to: RRJunctionT72, weight: 50)
        graph.addEdge(direction: .directed, from: RRJunctionT72, to: endT72, weight: 50)
        graph.addEdge(direction: .directed, from: endT72, to: T72JunctionDM, weight: 50)
//Sensation
        graph.addEdge(direction: .directed, from: topSensation, to: bend1Sensation, weight: 1)
        graph.addEdge(direction: .directed, from: bend1Sensation, to: bend2Sensation, weight: 1)
        graph.addEdge(direction: .directed, from: bend2Sensation, to: bend3Sensation, weight: 1)
        graph.addEdge(direction: .directed, from: bend3Sensation, to: QLJunctionSensation, weight: 1)
        graph.addEdge(direction: .directed, from: QLJunctionSensation, to: botAurora, weight: 1)
        graph.addEdge(direction: .undirected, from: QLJunctionSensation, to: botQLT, weight: 1)
//Quantum Leap
        graph.addEdge(direction: .undirected, from: topQLT, to: topQuantum, weight: 4000)
        graph.addEdge(direction: .undirected, from: topNP, to: topQuantum, weight: 4000)
        graph.addEdge(direction: .directed, from: topQuantum, to: backsideJunctionQL, weight: 4000)
        graph.addEdge(direction: .directed, from: backsideJunctionQL, to: bend1QL, weight: 4000)
        graph.addEdge(direction: .directed, from: bend1QL, to: QLJunctionSensation, weight: 4000)
//Quantum Leap Triple
        graph.addEdge(direction: .directed, from: botQLT, to: topQLT, weight: 100)
        graph.addEdge(direction: .undirected, from: topQLT, to: topNP, weight: 100)
//lowerdowndraft
        graph.addEdge(direction: .directed, from: topChondola, to: topLD, weight:  50)
        graph.addEdge(direction: .directed, from: topLD, to: GRJunctionLD, weight: 50)
        graph.addEdge(direction: .directed, from: GRJunctionLD, to: downdraftJunctionGR, weight:  50)
        graph.addEdge(direction: .directed, from: GRJunctionLD, to: AEJunctionLD, weight:  50)
//spruce triple
        graph.addEdge(direction: .directed, from: botSpruce, to: topSpruce, weight:  100)
//Sirius
        graph.addEdge(direction: .undirected, from: topSpruce, to: topSirius, weight: 1)
        graph.addEdge(direction: .undirected, from: topSirius, to: topDowndraft, weight: 1)
        graph.addEdge(direction: .directed, from: topSirius, to: endSirius, weight: 1)
        graph.addEdge(direction: .directed, from: endSirius, to: vortexJunctionBorealis, weight: 1)
//Upper Downdraft
        graph.addEdge(direction: .undirected, from: topSpruce, to: topDowndraft, weight: 1)
        graph.addEdge(direction: .directed, from: topDowndraft, to: endDowndraft, weight: 300)
        graph.addEdge(direction: .directed, from: endDowndraft, to: UpperDownDraftJunctionLO, weight: 300)
//American Express
        graph.addEdge(direction: .undirected, from: topSpruce, to: topAE, weight: 1)
        graph.addEdge(direction: .directed, from: topAE, to: TMLJunctionAE, weight: 50)
        graph.addEdge(direction: .undirected, from: TMLJunctionAE, to: AEJunction3ML, weight: 1)
        graph.addEdge(direction: .directed, from: TMLJunctionAE, to: bend1AE, weight: 50)
        graph.addEdge(direction: .directed, from: bend1AE, to: LRJunctionAE, weight: 50)
        graph.addEdge(direction: .directed, from: AEJunctionLD, to: LRJunctionAE, weight: 50)
        graph.addEdge(direction: .undirected, from: LRJunctionAE, to: AEJunctionLR, weight: 1)
//Risky Business
        graph.addEdge(direction: .undirected, from: topSpruce, to: topRB, weight: 1)
        graph.addEdge(direction: .directed, from: topRB, to: bend1RB, weight: 50)
        graph.addEdge(direction: .directed, from: bend1RB, to: bend2RB, weight: 50)
        graph.addEdge(direction: .undirected, from: bend2RB, to: RBJunction3ML, weight: 1)
        graph.addEdge(direction: .directed, from: bend2RB, to: LRJunctionRB, weight: 50)
        graph.addEdge(direction: .undirected, from: LRJunctionRB, to: RBJunctionLR, weight: 1)
//Gnarnia
        graph.addEdge(direction: .undirected, from: bend1RB, to: topGnarnia, weight: 1)
        graph.addEdge(direction: .directed, from: topGnarnia, to: TMLJunctionGnarnia, weight: 4000)
        graph.addEdge(direction: .undirected, from: TMLJunctionGnarnia, to: gnarniaJunction3ML, weight: 1)
        graph.addEdge(direction: .directed, from: TMLJunctionGnarnia, to: endGnarnia, weight: 4000)
        graph.addEdge(direction: .undirected, from: endGnarnia, to: gnarniaJunctionLR, weight: 1)
//Tourist Trap
        graph.addEdge(direction: .undirected, from: botSpruce, to: topTT, weight: 1)
        graph.addEdge(direction: .directed, from: topTT, to: OHJunctionTT, weight: 50)
        graph.addEdge(direction: .directed, from: OHJunctionTT, to: endTT, weight: 50)
        graph.addEdge(direction: .undirected, from: endTT, to: TTJunctionLSP, weight: 1)
//Barker
        graph.addEdge(direction: .directed, from: botBarker, to: topBarker, weight: 100)
//3 Mile Trail
        graph.addEdge(direction: .undirected, from: ThreeMLJunctionLR, to: start3ML, weight: 1)
        graph.addEdge(direction: .directed, from: start3ML, to: bend13ML, weight: 1)
        graph.addEdge(direction: .directed, from: bend13ML, to: bend23ML, weight: 1)
        graph.addEdge(direction: .directed, from: bend23ML, to: sluiceJunction3ML, weight: 1)
        graph.addEdge(direction: .directed, from: sluiceJunction3ML, to: gnarniaJunction3ML, weight: 1)
        graph.addEdge(direction: .directed, from: gnarniaJunction3ML, to: RBJunction3ML, weight: 1)
        graph.addEdge(direction: .directed, from: RBJunction3ML, to: AEJunction3ML, weight: 1)
        graph.addEdge(direction: .directed, from: AEJunction3ML, to: bend33ML, weight: 1)
        graph.addEdge(direction: .directed, from: bend33ML, to: end3ML, weight: 1)
        graph.addEdge(direction: .directed, from: end3ML, to: startSM, weight: 1)
        graph.addEdge(direction: .directed, from: end3ML, to: topLD, weight: 1)
        graph.addEdge(direction: .directed, from: end3ML, to: topChondola, weight: 1)
//Lazy River
        graph.addEdge(direction: .undirected, from: topBarker, to: startLR, weight: 1)
        graph.addEdge(direction: .directed, from: startLR, to: bend1LR, weight: 1)
        graph.addEdge(direction: .directed, from: bend1LR, to: ThreeMLJunctionLR, weight: 1)
        graph.addEdge(direction: .directed, from: ThreeMLJunctionLR, to: bend2LR, weight: 50)
        graph.addEdge(direction: .directed, from: bend2LR, to: bend3LR, weight: 50)
        graph.addEdge(direction: .directed, from: bend3LR, to: bend4LR, weight: 50)
        graph.addEdge(direction: .directed, from: bend4LR, to: sluiceJunctionLR, weight: 50)
        graph.addEdge(direction: .undirected, from: sluiceJunctionLR, to: endSluice, weight: 1)
        graph.addEdge(direction: .directed, from: sluiceJunctionLR, to: gnarniaJunctionLR, weight: 50)
        graph.addEdge(direction: .directed, from: gnarniaJunctionLR, to: RBJunctionLR, weight: 50)
        graph.addEdge(direction: .directed, from: RBJunctionLR, to: bend5LR, weight: 50)
        graph.addEdge(direction: .directed, from: bend5LR, to: botSpruce, weight: 50)
        graph.addEdge(direction: .directed, from: bend5LR, to: AEJunctionLR, weight: 50)
        graph.addEdge(direction: .directed, from: AEJunctionLR, to: GRJunctionLR, weight: 50)
        graph.addEdge(direction: .undirected, from: GRJunctionLR, to: lazyRiverJunctionGR, weight: 1)
        graph.addEdge(direction: .directed, from: GRJunctionLR, to: endLR, weight: 50)
        graph.addEdge(direction: .directed, from: endLR, to: topEL, weight: 50)
        graph.addEdge(direction: .directed, from: endLR, to: startThataway, weight: 50)
        graph.addEdge(direction: .directed, from: endLR, to: topLLR, weight: 50)
//Sluice
        graph.addEdge(direction: .undirected, from: sluiceJunction3ML, to: startSluice, weight: 1)
        graph.addEdge(direction: .directed, from: startSluice, to: bend1Sluice, weight: 50)
        graph.addEdge(direction: .directed, from: bend1Sluice, to: endSluice, weight: 50)
//Right Stuff
        graph.addEdge(direction: .undirected, from: topBarker, to: topRS, weight: 1)
        graph.addEdge(direction: .directed, from: topRS, to: bend1RS, weight: 300)
        graph.addEdge(direction: .directed, from: bend1RS, to: bend2RS, weight: 300)
        graph.addEdge(direction: .directed, from: bend2RS, to: bend3RS, weight: 300)
        graph.addEdge(direction: .directed, from: bend3RS, to: LSPJunctionRS, weight: 300)
        graph.addEdge(direction: .directed, from: LSPJunctionRS, to: LSPJunctionRS, weight: 50)
        graph.addEdge(direction: .undirected, from: LSPJunctionRS, to: RSJunctionLSP, weight: 1)
//Agony
        graph.addEdge(direction: .undirected, from: topBarker, to: topAgony, weight: 1)
        graph.addEdge(direction: .directed, from: topAgony, to: TGJunctionAgony, weight: 4000)
        graph.addEdge(direction: .undirected, from: TGJunctionAgony, to: topTG, weight: 1)
        graph.addEdge(direction: .directed, from: TGJunctionAgony, to: endAgony, weight: 4000)
        graph.addEdge(direction: .undirected, from: endAgony, to: agonyJunctionSP, weight: 1)
//Top Gun
        graph.addEdge(direction: .directed, from: topTG, to: bend1TG, weight: 4000)
        graph.addEdge(direction: .directed, from: bend1TG, to: LSPJunctionTG, weight: 4000)
        graph.addEdge(direction: .undirected, from: LSPJunctionTG, to: TGJunctionLSP, weight: 1)
//Ecstasy
        graph.addEdge(direction: .undirected, from: topBarker, to: topEcstasy, weight: 1)
        graph.addEdge(direction: .undirected, from: topEcstasy, to: startJR, weight: 1)
        graph.addEdge(direction: .directed, from: topEcstasy, to: bend1Ecstasy, weight: 50)
        graph.addEdge(direction: .directed, from: bend1Ecstasy, to: bend2Ecstasy, weight: 50)
        graph.addEdge(direction: .directed, from: bend2Ecstasy, to: southPawEcstasy, weight: 50)
        graph.addEdge(direction: .undirected, from: southPawEcstasy, to: topSP, weight: 50)
        graph.addEdge(direction: .directed, from: southPawEcstasy, to: uppercutJunctionEcstasy, weight: 50)
//Jungle Road
        graph.addEdge(direction: .undirected, from: startJR, to: topBarker, weight: 1)
        graph.addEdge(direction: .directed, from: startJR, to: bend1JR, weight: 50)
        graph.addEdge(direction: .directed, from: bend1JR, to: bend2JR, weight: 50)
        graph.addEdge(direction: .directed, from: bend2JR, to: GPJunctionJR, weight: 50)
        graph.addEdge(direction: .directed, from: GPJunctionJR, to: USPJunctionJR, weight: 50)
//Lower Upper Cut
        graph.addEdge(direction: .undirected, from: topLUC, to: uppercutJunctionEcstasy, weight: 1)
        graph.addEdge(direction: .directed, from: topLUC, to: botLUC, weight: 50)
        graph.addEdge(direction: .directed, from: botLUC, to: topLSP, weight: 50)
//South Paw
        graph.addEdge(direction: .directed, from: topSP, to: splitSP, weight: 50)
        graph.addEdge(direction: .directed, from: splitSP, to: LSPJunctionSP, weight: 50)
        graph.addEdge(direction: .undirected, from: LSPJunctionSP, to: SPJunctionuLSP, weight: 1)
        graph.addEdge(direction: .directed, from: splitSP, to: bend1SP, weight: 50)
        graph.addEdge(direction: .directed, from: bend1SP, to: bend2SP, weight: 50)
        graph.addEdge(direction: .directed, from: bend2SP, to: bend3SP, weight: 50)
        graph.addEdge(direction: .directed, from: bend3SP, to: agonyJunctionSP, weight: 50)
        graph.addEdge(direction: .directed, from: agonyJunctionSP, to: LSP2JunctionSP, weight: 50)
        graph.addEdge(direction: .undirected, from: LSP2JunctionSP, to: SPRCJunctionLSP, weight: 1)
//Lower Sunday Punch
        graph.addEdge(direction: .directed, from: topLSP, to: SPJunctionuLSP, weight: 50)
        graph.addEdge(direction: .directed, from: SPJunctionuLSP, to: bend1LSP, weight: 50)
        graph.addEdge(direction: .directed, from: topLSP, to: bend1LSP, weight: 50)
        graph.addEdge(direction: .directed, from: bend1LSP, to: SPRCJunctionLSP, weight: 50)
        graph.addEdge(direction: .undirected, from: SPRCJunctionLSP, to: topRC, weight: 1)
        graph.addEdge(direction: .directed, from: SPRCJunctionLSP, to: TGJunctionLSP, weight: 50)
        graph.addEdge(direction: .directed, from: TGJunctionLSP, to: RSJunctionLSP, weight: 50)
        graph.addEdge(direction: .directed, from: RSJunctionLSP, to: TTJunctionLSP, weight: 50)
        graph.addEdge(direction: .directed, from: TTJunctionLSP, to: endLSP, weight: 50)
        graph.addEdge(direction: .directed, from: endLSP, to: botBarker, weight: 50)
//Rocking Chair
        graph.addEdge(direction: .directed, from: topRC, to: bend1RC, weight: 50)
        graph.addEdge(direction: .directed, from: bend1RC, to: endRC, weight: 50)
        graph.addEdge(direction: .directed, from: endRC, to: botBarker, weight: 50)
//Tightwire
        graph.addEdge(direction: .directed, from: topLSP, to: topTW, weight: 1)
        graph.addEdge(direction: .directed, from: topTW, to: bend1TW, weight: 300)
        graph.addEdge(direction: .directed, from: bend1TW, to: RCJunctionTW, weight: 300)
        graph.addEdge(direction: .directed, from: RCJunctionTW, to: endRC, weight: 50)
//Southridge
        graph.addEdge(direction: .directed, from: botSouthridge, to: topSouthridge, weight: 100)
//Ridge Run
        graph.addEdge(direction: .undirected, from: topSouthridge, to: startRR, weight: 1)
        graph.addEdge(direction: .undirected, from: startRR, to: topLE, weight: 1)
        graph.addEdge(direction: .directed, from: EFJunctionRR, to: TDJunctionRR, weight: 1)
        graph.addEdge(direction: .undirected, from: TDJunctionRR, to: RRJunction3D, weight: 1)
        graph.addEdge(direction: .directed, from: TDJunctionRR, to: bend1RR, weight: 1)
        graph.addEdge(direction: .directed, from: bend1RR, to: T72JunctionRR, weight: 1)
        graph.addEdge(direction: .undirected, from:T72JunctionRR, to: RRJunctionT72, weight: 1)
        graph.addEdge(direction: .directed, from: T72JunctionRR, to: DMJunctionRR, weight: 1)
        graph.addEdge(direction: .undirected, from: RRJunctionDM, to: DMJunctionRR, weight: 1)
        graph.addEdge(direction: .directed, from: DMJunctionRR, to: LCJunctionRR, weight: 1)
        graph.addEdge(direction: .undirected, from: topST, to: STJunctionRR, weight: 1)
        graph.addEdge(direction: .directed, from: LCJunctionRR, to: STJunctionRR, weight: 1)
        graph.addEdge(direction: .directed, from: STJunctionRR, to: bend2RR, weight: 1)
        graph.addEdge(direction: .directed, from: bend2RR, to: bend3RR, weight: 1)
        graph.addEdge(direction: .directed, from: bend3RR, to: bend4RR, weight: 1)
        graph.addEdge(direction: .directed, from: bend4RR, to: bend5RR, weight: 1)
        graph.addEdge(direction: .directed, from: bend5RR, to: bend6RR, weight: 1)
        graph.addEdge(direction: .directed, from: bend6RR, to: endRR, weight: 1)
        graph.addEdge(direction: .directed, from: endRR, to: botSouthridge, weight: 1)
//Lower Escapade
        graph.addEdge(direction: .directed, from: LMJunctionEscapade, to: topLE, weight: 50)
        graph.addEdge(direction: .directed, from: topLE, to: EFJunctionRR, weight: 1)
        graph.addEdge(direction: .directed, from: topLE, to: broadwayJunctionLE, weight: 1)
        graph.addEdge(direction: .directed, from: broadwayJunctionLE, to: NWJunctionLE, weight: 1)
        graph.addEdge(direction: .directed, from: NWJunctionLE, to: endLE, weight: 1)
        graph.addEdge(direction: .directed, from: endLE, to: botNP, weight: 1)
//Broadway
        graph.addEdge(direction: .undirected, from: topSouthridge, to: topBroadway, weight: 1)
        graph.addEdge(direction: .directed, from: topBroadway, to: broadwayJunctionLE, weight: 1)
        graph.addEdge(direction: .directed, from: topBroadway, to: NWJunctionBroadway, weight: 1)
        graph.addEdge(direction: .directed, from: NWJunctionBroadway, to: MBJunctionBroadway, weight: 1)
        graph.addEdge(direction: .directed, from: MBJunctionBroadway, to: WVJunctionBroadway, weight: 1)
        graph.addEdge(direction: .directed, from: WVJunctionBroadway, to: WLJunctionBroadway, weight: 1)
        graph.addEdge(direction: .directed, from: WLJunctionBroadway, to: endBroadway, weight: 1)
        graph.addEdge(direction: .directed, from: endBroadway, to: botSouthridge, weight: 1)
        graph.addEdge(direction: .directed, from: endBroadway, to: botChondola, weight: 1)
//Lower Lazy River
        graph.addEdge(direction: .undirected, from: topSouthridge, to: topLLR, weight: 1)
        graph.addEdge(direction: .undirected, from: startThataway, to: topLLR, weight: 1)
        graph.addEdge(direction: .directed, from: topLLR, to: bend1LLR, weight: 1)
        graph.addEdge(direction: .directed, from: bend1LLR, to: broadwayJunctionLLR, weight: 1)
        graph.addEdge(direction: .undirected, from: bend1LLR, to: topLCL, weight: 1)
        graph.addEdge(direction: .directed, from: broadwayJunctionLLR, to: endLLR, weight: 1)
        graph.addEdge(direction: .directed, from: endLLR, to: botBarker, weight: 1)
        graph.addEdge(direction: .directed, from: broadwayJunctionLLR, to: WVJunctionBroadway, weight: 1)
        graph.addEdge(direction: .directed, from: MBJunctionBroadway, to: broadwayJunctionLLR, weight: 1)
//Thataway
        graph.addEdge(direction: .undirected, from: startThataway, to: endThataway, weight: 1)
        graph.addEdge(direction: .directed, from: endThataway, to: botSpruce, weight: 1)
//Mixing Bowl
        graph.addEdge(direction: .undirected, from: topSouthridge, to: topMB, weight: 1)
        graph.addEdge(direction: .directed, from: topMB, to: bend1MB, weight: 1)
        graph.addEdge(direction: .directed, from: bend1MB, to: endMB, weight: 1)
        graph.addEdge(direction: .directed, from: endMB, to: MBJunctionBroadway, weight: 1)
//Lower Chondi Line
        graph.addEdge(direction: .directed, from: topLCL, to: endLCL, weight: 1)
        graph.addEdge(direction: .directed, from: endLCL, to: WVJunctionBroadway, weight: 1)
//Who Ville
        graph.addEdge(direction: .directed, from: topWV, to: WVJunctionBroadway, weight: 1)
        graph.addEdge(direction: .directed, from: topWV, to: endWV, weight: 1)
        graph.addEdge(direction: .directed, from: endWV, to: endSpectator, weight: 1)
//Wonderland
        graph.addEdge(direction: .undirected, from: topWL, to: WLJunctionBroadway, weight: 1)
        graph.addEdge(direction: .directed, from: topWL, to: endWL, weight: 1)
//Northway
        graph.addEdge(direction: .undirected, from: NWJunctionBroadway, to: topNW, weight: 1)
        graph.addEdge(direction: .directed, from: topNW, to: LEJunctionNW, weight: 1)
        graph.addEdge(direction: .undirected, from: LEJunctionNW, to: NWJunctionLE, weight: 1)
        graph.addEdge(direction: .directed, from: LEJunctionNW, to: EFJunctionNW, weight: 1)
        graph.addEdge(direction: .directed, from: EFJunctionNW, to: endNW, weight: 1)
        graph.addEdge(direction: .directed, from: endNW, to: botNP, weight: 1)
//Spectator
        graph.addEdge(direction: .undirected, from: topSpectator, to: NWJunctionBroadway, weight: 1)
        graph.addEdge(direction: .directed, from: topSpectator, to: sundanceJunctionSpectator, weight: 1)
        graph.addEdge(direction: .directed, from: sundanceJunctionSpectator, to: endSpectator, weight: 1)
        graph.addEdge(direction: .directed, from: endSpectator, to: endBroadway, weight: 1)
//Double Dipper
        graph.addEdge(direction: .undirected, from: NWJunctionBroadway, to: topDD, weight: 1)
        graph.addEdge(direction: .directed, from: topDD, to:DMJunctionDD, weight: 1)
        graph.addEdge(direction: .undirected, from: DMJunctionDD, to: DMJunctionSD, weight: 1)
        graph.addEdge(direction: .directed, from: DMJunctionDD, to: endDD, weight: 1)
        graph.addEdge(direction: .directed, from: endDD, to: endBroadway, weight: 1)
// Sundance
        graph.addEdge(direction: .directed, from: WVJunctionBroadway, to: topSD, weight: 1)
        graph.addEdge(direction: .undirected, from: topSD, to: topWV, weight: 1)
        graph.addEdge(direction: .directed, from: topSD, to: DDSPRJunctionSD, weight: 1)
        graph.addEdge(direction: .undirected, from: DDSPRJunctionSD, to: sundanceJunctionSpectator, weight: 1)
        graph.addEdge(direction: .directed, from: DDSPRJunctionSD, to: DMJunctionSD, weight: 1)
        graph.addEdge(direction: .directed, from: endLE, to: DMJunctionSD, weight: 1)
        graph.addEdge(direction: .directed, from: DMJunctionSD, to: bend1SD, weight: 1)
        graph.addEdge(direction: .directed, from: bend1SD, to: botSD, weight: 1)
        graph.addEdge(direction: .directed, from: botSD, to: botSouthridge, weight: 1)
// second thoughts
        graph.addEdge(direction: .undirected, from: topST, to: STJunctionRR, weight: 1)
        graph.addEdge(direction: .directed, from: topST, to: bend1ST, weight: 1)
        graph.addEdge(direction: .directed, from: bend1ST, to: endST, weight: 1)
//Exit Right
        graph.addEdge(direction: .directed, from: LMJunctionEscapade, to: topER, weight: 1)
        graph.addEdge(direction: .directed, from: topER, to: endER, weight: 1)
        graph.addEdge(direction: .directed, from: endER, to: startThataway, weight: 1)
//Exit Left
        graph.addEdge(direction: .directed, from: endLR, to: topEL, weight: 1)
        graph.addEdge(direction: .directed, from: topEL, to: endEL, weight: 1)
        graph.addEdge(direction: .directed, from: endEL, to: topLE, weight: 1)
    }

    static func createAnnotation(title: String, latitude: Double, longitude: Double, difficulty: Difficulty) -> ImageAnnotation
    {
        let point = ImageAnnotation()
        point.title = title
        point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        point.difficulty = difficulty
        return point
    }
}
