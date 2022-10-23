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
        Trail(name: "Three Mile Trail", difficulty: .easy, annotations: [createAnnotation(title: "Three Mile Trail", latitude: 44.45995830676152, longitude: -70.87507133018418, difficulty: .easy), createAnnotation(title: "bend13ML", latitude: 44.45972825558672, longitude: -70.87556509196926, difficulty: .easy), createAnnotation(title: "bend23ML", latitude: 44.46103810206512, longitude: -70.87679718913374, difficulty: .easy), createAnnotation(title: "sluiceJunction3ML", latitude: 44.464324531330846, longitude: -70.87687849056759, difficulty: .easy), createAnnotation(title: "gnarniaJunction3ML", latitude: 44.465957595619486, longitude: -70.8768278709139, difficulty: .easy), createAnnotation(title: "RBJunction3ML", latitude: 44.46666992104078, longitude: -70.87694136884294, difficulty: .easy), createAnnotation(title: "AEJunction3ML", latitude: 44.46748978213407, longitude: -70.87829904642872, difficulty: .easy), createAnnotation(title: "bend33ML", latitude: 44.46769951569971, longitude: -70.87866743914817, difficulty: .easy), createAnnotation(title: "end3ML", latitude: 44.468481491163516, longitude: -70.87867359271134, difficulty: .easy)]),
        Trail(name: "Lazy River", difficulty: .intermediate, annotations: [createAnnotation(title: "Lazy River", latitude: 44.458918811247116, longitude: -70.87286678674761, difficulty: .easy), createAnnotation(title: "bend1LR", latitude: 44.45975604858868, longitude: -70.87375252691037, difficulty: .easy), createAnnotation(title: "3MLJunctionLR", latitude: 44.46004325902246, longitude: -70.87506172749464, difficulty: .easy), createAnnotation(title: "bend2LR", latitude: 44.46123880707136, longitude: -70.87588644774648, difficulty: .intermediate), createAnnotation(title: "bend3LR", latitude: 44.461611844923105, longitude: -70.8752208740192, difficulty: .intermediate), createAnnotation(title: "bend4LR", latitude: 44.46401321903339, longitude: -70.8742869902883, difficulty: .intermediate), createAnnotation(title: "sluiceJunctionLR", latitude: 44.46500701360254, longitude: -70.87456240448098, difficulty: .intermediate), createAnnotation(title: "gnarniaJunctionLR", latitude: 44.467083004155505, longitude: -70.87430538506386, difficulty: .intermediate), createAnnotation(title: "RBJunctionLR", latitude: 44.46761344275562, longitude: -70.87362002109518, difficulty: .intermediate), createAnnotation(title: "bend5LR", latitude: 44.46870630852191, longitude: -70.87166224609365, difficulty: .intermediate), createAnnotation(title: "AEJunctionLR", latitude: 44.46944563240094, longitude: -70.87141169656348, difficulty: .intermediate), createAnnotation(title: "GRJunctionLR", latitude: 44.470136513568576, longitude: -70.87047939858917, difficulty: .intermediate), createAnnotation(title: "endLR", latitude: 44.470801087998225, longitude: -70.87009348888205, difficulty: .intermediate)]),
        Trail(name: "Sluice", difficulty: .intermediate, annotations: [createAnnotation(title: "Sluice", latitude: 44.46431335555877, longitude: -70.87666657652473, difficulty: .intermediate), createAnnotation(title: "bend1Sluice", latitude: 44.46480932438971, longitude: -70.87626855163778, difficulty: .intermediate), createAnnotation(title: "endSluice", latitude: 44.46494612702607, longitude: -70.87483090477522, difficulty: .intermediate)]),
        Trail(name: "Right Stuff", difficulty: .advanced, annotations: [createAnnotation(title: "Right Stuff", latitude: 44.45967555335523, longitude: -70.87228900050134, difficulty: .advanced), createAnnotation(title: "bend1RS", latitude: 44.46211562332595, longitude: -70.87324457738133, difficulty: .advanced), createAnnotation(title: "bend2RS", latitude: 44.464038434182285, longitude: -70.87248702977574, difficulty: .advanced), createAnnotation(title: "bend3RS", latitude: 44.46654264712807, longitude: -70.86932668045823, difficulty: .advanced), createAnnotation(title: "LSPJunctionRS", latitude: 44.46751005332643, longitude: -70.8665321334552, difficulty: .advanced)]),
        Trail(name: "Agony", difficulty: .expertsOnly, annotations: [createAnnotation(title: "Agony", latitude: 44.45971601100833, longitude: -70.87176135368556, difficulty: .expertsOnly), createAnnotation(title: "TGJunctionAgony", latitude: 44.460472549774586, longitude: -70.87111695688282, difficulty: .expertsOnly), createAnnotation(title: "EndAgony", latitude: 44.46491262085675, longitude: -70.86704387714973, difficulty: .expertsOnly)]),
        //        Trail(name: "Hollywood", difficulty: .expertsOnly, annotations: []),
        Trail(name: "Top Gun", difficulty: .expertsOnly, annotations: [createAnnotation(title: "Top Gun", latitude: 44.46052492553666, longitude: -70.87122997646192, difficulty: .expertsOnly), createAnnotation(title: "bend1TG", latitude: 44.4632487372244, longitude: -70.87123330508894, difficulty: .expertsOnly), createAnnotation(title: "LSPJunctionTG", latitude: 44.46695531620989, longitude: -70.86638410668483, difficulty: .expertsOnly)]),
        Trail(name: "Ecstasy", difficulty: .intermediate, annotations: [createAnnotation(title: "Ecstasy", latitude: 44.45966692011528, longitude: -70.87135166364119, difficulty: .intermediate), createAnnotation(title: "bend1Ecstasy", latitude: 44.460016590788584, longitude: -70.87084852853677, difficulty: .intermediate), createAnnotation(title: "bend2Ecstasy", latitude: 44.46032795232815, longitude: -70.86718600985445, difficulty: .intermediate), createAnnotation(title: "southPawJunctionEcstasy", latitude: 44.461297881305626, longitude: -70.8663917106066, difficulty: .intermediate), createAnnotation(title: "uppercutJunctionEcstasy", latitude: 44.4613493437183, longitude: -70.86555394520701, difficulty: .intermediate)]),
        Trail(name: "Jungle Road", difficulty: .intermediate, annotations: [createAnnotation(title: "Jungle Road", latitude: 44.45966830075108, longitude: -70.87132308134012, difficulty: .intermediate), createAnnotation(title: "bend1JR", latitude: 44.459513174807036, longitude: -70.87016928026638, difficulty: .intermediate), createAnnotation(title: "bend2JR", latitude: 44.45902428223, longitude: -70.86971606313978, difficulty: .intermediate), createAnnotation(title: "GPJunctionJR", latitude: 44.45888651945049, longitude: -70.86907843269005, difficulty: .intermediate), createAnnotation(title: "USPJunctionJR", latitude: 44.45866032666825, longitude: -70.86775321054346, difficulty: .intermediate)]),
        Trail(name: "Lower Upper Cut", difficulty: .intermediate, annotations: [createAnnotation(title: "Lower Uppercut", latitude: 44.46137352810597, longitude: -70.86642583630629, difficulty: .intermediate), createAnnotation(title: "SPJunctinLUC", latitude: 44.46213546672406, longitude: -70.86638870223543, difficulty: .intermediate), createAnnotation(title: "bottomUppercut", latitude: 44.46253123478195, longitude: -70.86535354781799, difficulty: .intermediate)]),
        Trail(name: "Southpaw", difficulty: .intermediate, annotations: [createAnnotation(title: "Southpaw", latitude: 44.46276805273417, longitude: -70.86601223095431, difficulty: .intermediate), createAnnotation(title: "bend2SP", latitude: 44.46319899549631, longitude: -70.86688265387109, difficulty: .intermediate), createAnnotation(title: "bend3SouthPaw", latitude: 44.46375343519025, longitude: -70.86722425833486, difficulty: .intermediate), createAnnotation(title: "agonyJunctionSP", latitude: 44.464981534834564, longitude: -70.86704927562877, difficulty: .intermediate), createAnnotation(title: "LSPJunction2SP", latitude: 44.466084243678694, longitude: -70.86595438952699, difficulty: .intermediate)]),
        Trail(name: "Lower Sunday Punch", difficulty: .intermediate, annotations: [createAnnotation(title: "Lower Sunday Punch", latitude: 44.462333820213146, longitude: -70.86448440473603, difficulty: .intermediate), createAnnotation(title: "LUCJunctionLSP", latitude: 44.4625240631385, longitude: -70.86520501198373, difficulty: .intermediate), createAnnotation(title: "bend1SP", latitude: 44.46367022702908, longitude: -70.86500787270711, difficulty: .intermediate), createAnnotation(title: "SP&RCJunctionLSP", latitude: 44.466043015366544, longitude: -70.86592477230046, difficulty: .intermediate), createAnnotation(title: "TGJunctionLSP", latitude: 44.4669271429763, longitude: -70.8661816527247, difficulty: .intermediate), createAnnotation(title: "RSJunctionLSP", latitude: 44.46749072664456, longitude: -70.86647954730529, difficulty: .intermediate), createAnnotation(title: "TTJunctionLSP", latitude: 44.46954650476462, longitude: -70.86438018168907, difficulty: .intermediate), createAnnotation(title: "endLSP", latitude: 44.46971832425021, longitude: -70.86315139834717, difficulty: .intermediate)]),
        Trail(name: "Rocking Chair", difficulty: .intermediate, annotations: [createAnnotation(title: "Rocking Chair", latitude: 44.46633242158953, longitude: -70.86542313921537, difficulty: .intermediate), createAnnotation(title: "bend1RC", latitude: 44.46893816110395, longitude: -70.86396468658349, difficulty: .intermediate), createAnnotation(title: "endRC", latitude: 44.46955007566205, longitude: -70.86287985731924, difficulty: .intermediate)]),
        Trail(name: "Tightwire", difficulty: .advanced, annotations: [createAnnotation(title: "Tightwire", latitude: 44.46315831820998, longitude: -70.86468326750321, difficulty: .advanced), createAnnotation(title: "bend1TW", latitude: 44.46641701498706, longitude: -70.86342087036127, difficulty: .advanced), createAnnotation(title: "RCJunctionTW", latitude: 44.467342723580636, longitude: -70.86453099495536, difficulty: .advanced)])]
    
    static let southRidgeTrails : [Trail] = [
        Trail(name: "Ridge Run", difficulty: .easy, annotations: [createAnnotation(title: "Ridge Run", latitude: 44.47162071063281, longitude: -70.86932648218762, difficulty: .easy), createAnnotation(title: "EFJunctionRR", latitude: 44.47261225258012, longitude: -70.86990943502828, difficulty: .easy), createAnnotation(title: "3DJunctionRR", latitude: 44.473566373346806, longitude: -70.87061356821667, difficulty: .easy), createAnnotation(title: "bend1RR", latitude: 44.47397519114789, longitude: -70.87096271327214, difficulty: .easy), createAnnotation(title: "T72JunctionRR", latitude: 44.47471498969679, longitude: -70.87081490034599, difficulty: .easy), createAnnotation(title: "DMJunctionRR", latitude: 44.47547018726526, longitude: -70.87077704736517, difficulty: .easy), createAnnotation(title: "STJunctionRR", latitude: 44.47549070157672, longitude: -70.87076078836633, difficulty: .easy), createAnnotation(title: "LCJunctionRR", latitude: 44.47642562084904, longitude: -70.87058426814676, difficulty: .easy), createAnnotation(title: "bend2RR", latitude: 44.477270343557755, longitude: -70.86901116770413, difficulty: .easy), createAnnotation(title: "bend3RR", latitude: 44.47805677665824, longitude: -70.86628295857128, difficulty: .easy), createAnnotation(title: "bend4RR", latitude: 44.477370343898286, longitude: -70.86223738949299, difficulty: .easy), createAnnotation(title: "bend5RR", latitude: 44.47528005782332, longitude: -70.85938331721208, difficulty: .easy), createAnnotation(title: "bend6RR", latitude: 44.474310447199095, longitude: -70.8586525348936, difficulty: .easy), createAnnotation(title: "endRR", latitude: 44.473842509608566, longitude: -70.85888489822734, difficulty: .easy)]),
        Trail(name: "Lower Escapade", difficulty: .easy, annotations: [createAnnotation(title: "Lower Escapade", latitude: 44.47186608016329, longitude: -70.86945449960109, difficulty: .easy), createAnnotation(title: "BroadwayJunctionLE", latitude: 44.47186608016329, longitude: -70.86945449960109, difficulty: .easy), createAnnotation(title: "NWJunctionLE", latitude: 44.47315536119423, longitude: -70.86574560528885, difficulty: .easy), createAnnotation(title: "endLE", latitude: 44.473892525500894, longitude: -70.86457915169618, difficulty: .easy)]),
        Trail(name: "Broadway", difficulty: .easy, annotations: [createAnnotation(title: "Broadway", latitude: 44.471513238602334, longitude: -70.86920055180396, difficulty: .easy), createAnnotation(title: "NWJunctionBroadway", latitude: 44.471887698950034, longitude: -70.8661872983771, difficulty: .easy), createAnnotation(title: "MBJunctionBroadway", latitude: 44.47158910946508, longitude: -70.8644627972387, difficulty: .easy), createAnnotation(title: "WVJunctionBroadway", latitude: 44.47170856243638, longitude: -70.86377512631796, difficulty: .easy), createAnnotation(title: "WLJunctionBroadway", latitude: 44.471612194301656, longitude: -70.86164965039356, difficulty: .easy), createAnnotation(title: "endBroadway", latitude: 44.473152286875425, longitude: -70.85843285655504, difficulty: .easy)]),
        Trail(name: "Lower Lazy River", difficulty: .easy, annotations: [createAnnotation(title: "Lower Lazy River", latitude: 44.47094252731932, longitude: -70.86882825160487, difficulty: .easy), createAnnotation(title: "bend1LLR", latitude: 44.470738578779034, longitude: -70.8675201983097, difficulty: .easy), createAnnotation(title: "broadwayJunctionLLR", latitude: 44.47131969568009, longitude: -70.86401012794902, difficulty: .easy), createAnnotation(title: "endLLR", latitude: 44.47078330161824, longitude: -70.86233471871473, difficulty: .easy)]),
        Trail(name: "Thataway", difficulty: .easy, annotations: [createAnnotation(title: "Thataway", latitude: 44.47085254666974, longitude: -70.86896670777054, difficulty: .easy), createAnnotation(title: "endThataway", latitude: 44.46975772026796, longitude: -70.86886894893023, difficulty: .easy)]),
        Trail(name: "Mixing Bowl", difficulty: .easy, annotations: [createAnnotation(title: "Mixing Bowl", latitude: 44.471302120911304, longitude: -70.86878079872398, difficulty: .easy), createAnnotation(title: "bend1MB", latitude: 44.47132044453957, longitude: -70.8665553011726, difficulty: .easy), createAnnotation(title: "endMixingBowl", latitude: 44.47160896486826, longitude: -70.86496105485335, difficulty: .easy)]),
        Trail(name: "Lower Chondi Line", difficulty: .easy, annotations: [createAnnotation(title: "Lower Chondi Line", latitude: 44.47091183832565, longitude: -70.86718397308259, difficulty: .easy), createAnnotation(title: "endLCL", latitude: 44.47143002814015, longitude: -70.86490148014812, difficulty: .easy)]),
        Trail(name: "WhoVille", difficulty: .terrainPark, annotations: [createAnnotation(title: "Who-Ville", latitude: 44.47189644908563, longitude: -70.86329936753248, difficulty: .terrainPark), createAnnotation(title: "endWV", latitude: 44.47308643515055, longitude: -70.85954960379576, difficulty: .terrainPark)]),
        Trail(name: "Wonderland", difficulty: .terrainPark, annotations: [createAnnotation(title: "Wonderland", latitude: 44.47155200691823, longitude: -70.86108394226666, difficulty: .terrainPark), createAnnotation(title: "endWonderland", latitude: 44.471703973166186, longitude: -70.86008848766531, difficulty: .terrainPark)]),
        Trail(name: "Northway", difficulty: .easy, annotations: [createAnnotation(title: "Northway", latitude: 44.47220538401174, longitude: -70.8662171943399, difficulty: .easy), createAnnotation(title: "LEJunctionNW", latitude: 44.47315536119423, longitude: -70.86594930854713, difficulty: .easy), createAnnotation(title: "EFJunctionNW", latitude: 44.47365565297179, longitude: -70.86574560528885, difficulty: .easy), createAnnotation(title: "endNW", latitude: 44.47442726961685, longitude: -70.8656957450711, difficulty: .easy)]),
        Trail(name: "Spectator", difficulty: .easy, annotations: [createAnnotation(title: "Spectator", latitude: 44.47205048836813, longitude: -70.86574022287715, difficulty: .easy), createAnnotation(title: "sundanceJunctionSpectator", latitude: 44.472470386120186, longitude: -70.86327947361386, difficulty: .easy), createAnnotation(title: "endSpectator", latitude: 44.47326843184697, longitude: -70.85944443654387, difficulty: .easy)]),
        Trail(name: "Double Dipper", difficulty: .easy, annotations: [createAnnotation(title: "Double Dipper", latitude: 44.47221857294215, longitude: -70.8658617554617, difficulty: .easy), createAnnotation(title: "DMJunctionDD", latitude: 44.47307378992409, longitude: -70.86191876720088, difficulty: .easy), createAnnotation(title: "endDD", latitude: 44.47350477003316, longitude: -70.85933421055354, difficulty: .easy)]),
        Trail(name: "Sundance", difficulty: .easy, annotations: [createAnnotation(title: "Sundance", latitude: 44.47216841473903, longitude: -70.8634803194262, difficulty: .easy), createAnnotation(title: "DD&SPRJunctionSD", latitude: 44.472564511416515, longitude: -70.86321930085626, difficulty: .easy), createAnnotation(title: "RRJunctionSD", latitude: 44.47319380222498, longitude: -70.86221130612768, difficulty: .easy), createAnnotation(title: "bend1Sundance", latitude: 44.47362558473599, longitude: -70.86151793333684, difficulty: .easy), createAnnotation(title: "botSundance", latitude: 44.47378191784132, longitude: -70.85906270396109, difficulty: .easy)]),
        Trail(name: "Second Thoughts", difficulty: .easy, annotations: [createAnnotation(title: "Second Thoughts", latitude: 44.47638729191411, longitude: -70.870552774431, difficulty: .easy), createAnnotation(title: "bend1ST", latitude: 44.47629604259682, longitude: -70.86976874309151, difficulty: .easy), createAnnotation(title: "endSecondThoughts", latitude: 44.475530029337875, longitude: -70.86868889749921, difficulty: .easy)]),
        Trail(name: "Exit Right", difficulty: .easy, annotations: [createAnnotation(title: "Exit Right", latitude: 44.47135372033121, longitude: -70.86992747990317, difficulty: .easy), createAnnotation(title: "endER", latitude: 44.470999193012005, longitude: -70.86952416392006, difficulty: .easy)]),
        Trail(name: "Exit Left", difficulty: .easy, annotations: [createAnnotation(title: "Exit Left", latitude: 44.471211769327596, longitude: -70.8696094100586, difficulty: .easy), createAnnotation(title: "endEL", latitude: 44.471840249971066, longitude: -70.86955148201567, difficulty: .easy)])]
    
    static let lockeTrails = [
        Trail(name: "Goat Path", difficulty: .intermediate, annotations: [createAnnotation(title: "Goat Path", latitude: 44.45743693264429, longitude: -70.86818892101017, difficulty: .intermediate), createAnnotation(title: "UCJunctionGP", latitude: 44.45786227278814, longitude: -70.86913280437817, difficulty: .intermediate), createAnnotation(title: "JRJunctionGP", latitude: 44.45886904088148, longitude: -70.86905920108418, difficulty: .intermediate), createAnnotation(title: "EcstasyJunctionGP", latitude: 44.46009835256276, longitude: -70.86883828571136, difficulty: .intermediate), createAnnotation(title: "bend2GP", latitude: 44.4603351555924, longitude: -70.86913902016163, difficulty: .intermediate), createAnnotation(title: "bend3GP", latitude: 44.460895287117395, longitude: -70.87009791704583, difficulty: .intermediate), createAnnotation(title: "agonyJunctionGP", latitude: 44.46124547051831, longitude: -70.87023187988675, difficulty: .intermediate), createAnnotation(title: "TGJunctionGP", latitude: 44.46140278721097, longitude: -70.87133062704991, difficulty: .intermediate), createAnnotation(title: "LRJunctionGP", latitude: 44.46135362157697, longitude: -70.87305328528684, difficulty: .intermediate)]),
        Trail(name: "Upper Cut", difficulty: .advanced, annotations: [createAnnotation(title: "Upper Cut", latitude: 44.45793322767762, longitude: -70.8690652225351, difficulty: .advanced), createAnnotation(title: "JRJunctionUC", latitude: 44.458659942193506, longitude: -70.86819410200806, difficulty: .advanced), createAnnotation(title: "bend1UC", latitude: 44.45904928433035, longitude: -70.86815468450483, difficulty: .advanced), createAnnotation(title: "ecstasyJunctionUC", latitude: 44.46032095392963, longitude: -70.86720227324808, difficulty: .advanced)]),
        Trail(name: "Upper Sunday Punch", difficulty: .intermediate, annotations: [createAnnotation(title: "Upper Sunday Punch", latitude: 44.4574192254598, longitude: -70.86788675882315, difficulty: .intermediate), createAnnotation(title: "JRJunctionUSP", latitude: 44.45864423452321, longitude: -70.86772065119717, difficulty: .intermediate), createAnnotation(title: "bend1USP", latitude: 44.459633787036026, longitude: -70.86672485549994, difficulty: .intermediate), createAnnotation(title: "bend2USP", latitude: 44.460100490638666, longitude: -70.86651829141081, difficulty: .intermediate), createAnnotation(title: "LLJunctionUSP", latitude: 44.460316145138286, longitude: -70.86593615911332, difficulty: .intermediate), createAnnotation(title: "bend3USP", latitude: 44.46078125137312, longitude: -70.86496726250363, difficulty: .intermediate), createAnnotation(title: "grandJunctionUSP", latitude: 44.46152436542715, longitude: -70.86443787795557, difficulty: .intermediate)]),
        Trail(name: "Locke Line", difficulty: .advanced, annotations: [createAnnotation(title: "Locke Line", latitude: 44.457868805088665, longitude: -70.86697109813392, difficulty: .advanced), createAnnotation(title: "JWJunctionLL", latitude: 44.45863048641886, longitude: -70.86667068086437, difficulty: .advanced), createAnnotation(title: "USPJunctionLL", latitude: 44.46030460534658, longitude: -70.86598076630092, difficulty: .advanced), createAnnotation(title: "EcstasyJunctionLL", latitude: 44.461333789549116, longitude: -70.86555690159848, difficulty: .advanced)]),
        Trail(name: "Jim's Whim", difficulty: .advanced, annotations: [createAnnotation(title: "Jim's Whim", latitude: 44.45866621943885, longitude: -70.86744632797787, difficulty: .advanced), createAnnotation(title: "LLJunctionJW", latitude: 44.45864321190542, longitude: -70.86672052994747, difficulty: .advanced), createAnnotation(title: "T2JunctionJW", latitude: 44.45889175995814, longitude: -70.86563375333701, difficulty: .advanced)]),
        Trail(name: "T2", difficulty: .advanced, annotations: [createAnnotation(title: "T2", latitude: 44.45735978792861, longitude: -70.86737398311872, difficulty: .advanced), createAnnotation(title: "LLJunctionT2", latitude: 44.45784138370962, longitude: -70.86671774296467, difficulty: .advanced), createAnnotation(title: "JWJunctionT2", latitude: 44.45888746743546, longitude: -70.86561181370546, difficulty: .advanced), createAnnotation(title: "EndT2", latitude: 44.46141599281048, longitude: -70.8640310915411, difficulty: .advanced)]),
        Trail(name: "Bim's Whim", difficulty: .advanced, annotations: [createAnnotation(title: "Bim's Whim", latitude: 44.456793321867444, longitude: -70.86712462149937, difficulty: .advanced), createAnnotation(title: "bend1BW", latitude: 44.456946452067335, longitude: -70.86630273398389, difficulty: .advanced), createAnnotation(title: "bend2BW", latitude: 44.4568473617074, longitude: -70.86612639969591, difficulty: .advanced), createAnnotation(title: "bend3BW", latitude: 44.45732031661159, longitude: -70.86470570901785, difficulty: .advanced), createAnnotation(title: "bend4BW", latitude: 44.45754295004562, longitude: -70.86285456570242, difficulty: .advanced), createAnnotation(title: "bend5BW", latitude: 44.457997380038236, longitude: -70.8626604982426, difficulty: .advanced), createAnnotation(title: "SalvationJunctionBW", latitude: 44.45853385118159, longitude: -70.86296829173801, difficulty: .advanced), createAnnotation(title: "WCJunctionBW", latitude: 44.45820011192838, longitude: -70.86006621322885, difficulty: .advanced)]),
        Trail(name: "Cascades", difficulty: .intermediate, annotations: [createAnnotation(title: "Cascades", latitude: 44.46255933194429, longitude: -70.86203560633224, difficulty: .intermediate), createAnnotation(title: "SnowboundJunctionCascades", latitude: 44.46319273953846, longitude: -70.86139710396205, difficulty: .intermediate), createAnnotation(title: "TempestJunctionCascades", latitude: 44.46462844765911, longitude: -70.86130681480886, difficulty: .intermediate), createAnnotation(title: "endCascades", latitude: 44.46878916321214, longitude: -70.86107505455976, difficulty: .intermediate)]),
        Trail(name: "Monday Mourning", difficulty: .advanced, annotations: [createAnnotation(title: "Monday Mourning", latitude: 44.462402841818104, longitude: -70.8633472124859, difficulty: .advanced), createAnnotation(title: "endMM", latitude: 44.46900202714522, longitude: -70.86215258113216, difficulty: .advanced)]),
        Trail(name: "Bear Paw", difficulty: .easy, annotations: [createAnnotation(title: "Bear Paw", latitude: 44.464488845043874, longitude: -70.85983989724394, difficulty: .easy), createAnnotation(title: "bend1BP", latitude: 44.46512084628069, longitude: -70.86087861514909, difficulty: .easy), createAnnotation(title: "bend2BP", latitude: 44.46564809786406, longitude: -70.85988118338261, difficulty: .easy), createAnnotation(title: "bend3BP", latitude: 44.46581879162974, longitude: -70.8608567740475, difficulty: .easy), createAnnotation(title: "bend4BP", latitude: 44.466301304643146, longitude: -70.8598652996761, difficulty: .easy), createAnnotation(title: "bend5BP", latitude: 44.46661617345175, longitude: -70.86027643202667, difficulty: .easy), createAnnotation(title: "cutOffJunctionBP", latitude: 44.46724231626774, longitude: -70.8600064219411, difficulty: .easy), createAnnotation(title: "endCutOffJunctionBP", latitude: 44.46747235977663, longitude: -70.86040408841197, difficulty: .easy), createAnnotation(title: "bend6BP", latitude: 44.468299103853134, longitude: -70.8596350907055, difficulty: .easy), createAnnotation(title: "endBP", latitude: 44.468980738321356, longitude: -70.86091806671445, difficulty: .easy)]),
        Trail(name: "WildFire", difficulty: .intermediate, annotations: [createAnnotation(title: "WildFire", latitude: 44.46476940739254, longitude: -70.85985454988528, difficulty: .intermediate), createAnnotation(title: "bend1WF", latitude: 44.46607118239925, longitude: -70.85928376323406, difficulty: .intermediate), createAnnotation(title: "COJunctionWF", latitude: 44.46704711700395, longitude: -70.85951170909081, difficulty: .intermediate), createAnnotation(title: "CBJunctionWF", latitude: 44.4681116238182, longitude: -70.85925461516578, difficulty: .intermediate), createAnnotation(title: "endWF", latitude: 44.4695193767508, longitude: -70.85819717521642, difficulty: .intermediate)]),
        Trail(name: "Cut Off", difficulty: .intermediate, annotations: [createAnnotation(title: "Cut Off", latitude: 44.46718599867918, longitude: -70.85977825361167, difficulty: .intermediate), createAnnotation(title: "endCutOff", latitude: 44.46757047502923, longitude: -70.86058997806956, difficulty: .intermediate)]),
        Trail(name: "Cut Back", difficulty: .intermediate, annotations: [createAnnotation(title: "Cut Back", latitude: 44.46822319671841, longitude: -70.85944907531936, difficulty: .intermediate)]),
        Trail(name: "RoadRunner", difficulty: .easy, annotations: [createAnnotation(title: "Road Runner", latitude: 44.46917904218135, longitude: -70.86087320257772, difficulty: .easy), createAnnotation(title: "WFJunctionRR", latitude: 44.46959335316187, longitude: -70.85819076306049, difficulty: .easy), createAnnotation(title: "bend1RR", latitude: 44.47009494574761, longitude: -70.85451613671009, difficulty: .easy), createAnnotation(title: "bend2RR", latitude: 44.470044402373766, longitude: -70.85152006733094, difficulty: .easy), createAnnotation(title: "endRR", latitude: 44.469276188899386, longitude: -70.8481848535303, difficulty: .easy)]),
        Trail(name: "Snowbound", difficulty: .advanced, annotations: [createAnnotation(title: "Snowbound", latitude: 44.4631925840547, longitude: -70.86116574162392, difficulty: .advanced), createAnnotation(title: "endSnowbound", latitude: 44.46296477969226, longitude: -70.85888925862076, difficulty: .advanced)])]
    
    static let whiteCapTrails = [
        Trail(name: "Salvation", difficulty: .intermediate, annotations: [createAnnotation(title: "Salvation", latitude: 44.458483169096866, longitude: -70.86042598349411, difficulty: .intermediate), createAnnotation(title: "BWJunctionSalvation", latitude: 44.45863953323299, longitude: -70.86282693916186, difficulty: .intermediate), createAnnotation(title: "bend1Salvation", latitude: 44.45914311488431, longitude: -70.86304708493333, difficulty: .intermediate), createAnnotation(title: "BW2JunctionSalvation", latitude: 44.45951743622001, longitude: -70.86368555648342, difficulty: .intermediate), createAnnotation(title: "HOJunctionSalvation", latitude: 44.46083349948976, longitude: -70.86157913730908, difficulty: .intermediate)]),
        Trail(name: "Heat's Off", difficulty: .intermediate, annotations: [createAnnotation(title: "Heat's Off", latitude: 44.46083349948976, longitude: -70.86157913730908, difficulty: .intermediate), createAnnotation(title: "endHO", latitude: 44.46268057168865, longitude: -70.86187494293544, difficulty: .intermediate)]),
        Trail(name: "Obsession", difficulty: .advanced, annotations: [createAnnotation(title: "Obsession", latitude: 44.45861688693798, longitude: -70.86018982712098, difficulty: .advanced), createAnnotation(title: "bend1Obsession", latitude: 44.45958572242971, longitude: -70.86133536613758, difficulty: .advanced), createAnnotation(title: "HOJunctionObsession", latitude: 44.460737029836885, longitude: -70.86133253499462, difficulty: .advanced), createAnnotation(title: "SBJunctionObsession", latitude: 44.46288071586098, longitude: -70.85875946536018, difficulty: .advanced), createAnnotation(title: "bend2Obsesion", latitude: 44.46337555152756, longitude: -70.8561913746322, difficulty: .advanced), createAnnotation(title: "HeatsOnJunctionObsession", latitude: 44.46547977559036, longitude: -70.85364710455535, difficulty: .advanced)]),
        Trail(name: "Chutzpah", difficulty: .expertsOnly, annotations: [createAnnotation(title: "Chutzpah", latitude: 44.45901194158459, longitude: -70.860380099453, difficulty: .expertsOnly), createAnnotation(title: "MidChutzpah", latitude: 44.46214269678367, longitude: -70.85745309749989, difficulty: .expertsOnly), createAnnotation(title: "endChutzpah", latitude: 44.461963173473954, longitude: -70.85540487916239, difficulty: .expertsOnly)]),
        Trail(name: "White Heat", difficulty: .expertsOnly, annotations: [createAnnotation(title: "White Heat", latitude: 44.45838692332843, longitude: -70.85947594677012, difficulty: .expertsOnly), createAnnotation(title: "ChutzpahJunctionWhiteHeat", latitude: 44.461596501445776, longitude: -70.85561722954975, difficulty: .expertsOnly), createAnnotation(title: "assumptionJunctionWH", latitude: 44.46370782925331, longitude: -70.85331858123513, difficulty: .expertsOnly)]),
        Trail(name: "Shock Wave", difficulty: .expertsOnly, annotations: [createAnnotation(title: "Shock Wave", latitude: 44.45848257576402, longitude: -70.85790599684091, difficulty: .expertsOnly), createAnnotation(title: "bend1SW", latitude: 44.45960664537479, longitude: -70.8547128689182, difficulty: .expertsOnly), createAnnotation(title: "bend2SW", latitude: 44.461373052305674, longitude: -70.8532714749393, difficulty: .expertsOnly), createAnnotation(title: "AssumptionJunctionSW", latitude: 44.46271957527544, longitude: -70.85286952077271, difficulty: .expertsOnly)]),
        Trail(name: "Tempest", difficulty: .advanced, annotations: [createAnnotation(title: "Tempest", latitude: 44.46482488905358, longitude: -70.8587707158816, difficulty: .advanced), createAnnotation(title: "HOJunctionTempest", latitude: 44.46603844515163, longitude: -70.855317539413, difficulty: .advanced), createAnnotation(title: "endTempest", latitude: 44.469034451416476, longitude: -70.84817301469715, difficulty: .advanced)]),
        Trail(name: "Jibe", difficulty: .intermediate, annotations: [createAnnotation(title: "Jibe", latitude: 44.46512557360144, longitude: -70.85876598010631, difficulty: .intermediate), createAnnotation(title: "bend1Jibe", latitude: 44.46552726157362, longitude: -70.85823410644056, difficulty: .intermediate), createAnnotation(title: "endJibe", latitude: 44.466469707015264, longitude: -70.85598289488675, difficulty: .intermediate)]),
        Trail(name: "Heat's On", difficulty: .intermediate, annotations: [createAnnotation(title: "Heat's On", latitude: 44.46590669415151, longitude: -70.85504936042102, difficulty: .intermediate), createAnnotation(title: "ObsessionJunctionHO", latitude: 44.465541588293874, longitude: -70.85386633860739, difficulty: .intermediate), createAnnotation(title: "AssumptionJunctionHO", latitude: 44.46567086608029, longitude: -70.85110689345942, difficulty: .intermediate), createAnnotation(title: "SLJunctionHO", latitude: 44.46620634074322, longitude: -70.85033639377404, difficulty: .intermediate)]),
        Trail(name: "Green Cheese", difficulty: .easy, annotations: [createAnnotation(title: "Green Cheese", latitude: 44.462265201253445, longitude: -70.85158965848217, difficulty: .easy), createAnnotation(title: "SBJunctionGC", latitude: 44.46213288954053, longitude: 70.85059284065638, difficulty: .easy), createAnnotation(title: "endGC", latitude: 44.46176576523678, longitude: -70.84931075831236, difficulty: .easy)]),
        Trail(name: "Moonstruck", difficulty: .easy, annotations: [createAnnotation(title: "Moonstruck", latitude: 44.46079516912933, longitude: -70.85026015889024, difficulty: .easy), createAnnotation(title: "bend1MS", latitude: 44.46085327095977, longitude: -70.84989915934273, difficulty: .easy), createAnnotation(title: "bend2MS", latitude: 44.46135270602178, longitude: -70.84987433985663, difficulty: .easy), createAnnotation(title: "bend3MS", latitude: 44.46127079293708, longitude: -70.84896739753873, difficulty: .easy), createAnnotation(title: "GCJunctionMS", latitude: 44.46182136930712, longitude: -70.8486231038866, difficulty: .easy), createAnnotation(title: "bend4MS", latitude: 44.46245505222505, longitude: -70.84807118332712, difficulty: .easy), createAnnotation(title: "SBJunctionMS", latitude: 44.466192032922756, longitude: -70.84822477145208, difficulty: .easy), createAnnotation(title: "SLJunctoinMS", latitude: 44.46759456175538, longitude: -70.84810232442435, difficulty: .easy), createAnnotation(title: "endMS", latitude: 44.469005066431215, longitude: -70.84810366431672, difficulty: .easy)]),
        Trail(name: "Assumption", difficulty: .intermediate, annotations: [createAnnotation(title: "Assumption", latitude: 44.46211663889562, longitude: -70.85213502446611, difficulty: .intermediate), createAnnotation(title: "SWJunctionAssumption", latitude: 44.46284413935481, longitude: -70.85284153508444, difficulty: .intermediate), createAnnotation(title: "WHJunctionAssumption", latitude: 44.46381318866854, longitude: -70.85318276236255, difficulty: .intermediate), createAnnotation(title: "WHQJunctionAssumption", latitude: 44.46519273562941, longitude: -70.85141179195095, difficulty: .intermediate)]),
        Trail(name: "Starlight", difficulty: .easy, annotations: [createAnnotation(title: "Starlight", latitude: 44.46214972089107, longitude: -70.851891613998, difficulty: .easy), createAnnotation(title: "bend1SL", latitude: 44.4629594163276, longitude: -70.85190334866245, difficulty: .easy), createAnnotation(title: "bend2SL", latitude: 44.463883328813466, longitude: -70.85116096349854, difficulty: .easy), createAnnotation(title: "bend3SL", latitude: 44.464610149234666, longitude: -70.84984320259143, difficulty: .easy), createAnnotation(title: "HOJunctionSL", latitude: 44.46623164400667, longitude: -70.85018753117372, difficulty: .easy), createAnnotation(title: "MSJunctionSL", latitude: 44.467428332277954, longitude: -70.84831270898182, difficulty: .easy)]),
        Trail(name: "Starstruck", difficulty: .advanced, annotations: [createAnnotation(title: "Starstruck", latitude: 44.462366577991936, longitude: -70.85023061415602, difficulty: .advanced), createAnnotation(title: "endSS", latitude: 44.465180263232845, longitude: -70.84833131680686, difficulty: .advanced)]),
        Trail(name: "Starwood", difficulty: .advanced, annotations: [createAnnotation(title: "Starwood", latitude: 44.46241446591349, longitude: -70.8507002102812, difficulty: .advanced), createAnnotation(title: "endSW", latitude: 44.46396229245787, longitude: -70.85054627662946, difficulty: .advanced)]),
        Trail(name: "Starburst", difficulty: .intermediate, annotations: [createAnnotation(title: "Starburst", latitude: 44.461385599781984, longitude: -70.85104671815832, difficulty: .intermediate), createAnnotation(title: "GCJunctionSB", latitude: 44.462125462757015, longitude: -70.85059522694398, difficulty: .intermediate), createAnnotation(title: "endSB", latitude: 44.465833998663086, longitude: -70.84866001313974, difficulty: .intermediate)])]
    
    static let spruceTrails : [Trail] = [
        Trail(name: "Sirius", difficulty: .easy, annotations: [createAnnotation(title: "Sirius", latitude: 44.46402015560722, longitude: -70.88287192667336, difficulty: .easy), createAnnotation(title: "endSirius", latitude: 44.463942115466686, longitude: -70.88490373252286, difficulty: .easy)]),
        Trail(name: "Upper Downdraft", difficulty: .advanced, annotations: [createAnnotation(title: "Upper Downdraft", latitude: 44.46400513990251, longitude: -70.88273316778006, difficulty: .advanced), createAnnotation(title: "endDowndraft", latitude: 44.466716217333456, longitude: -70.88179847448035, difficulty: .advanced)]),
        Trail(name: "American Express", difficulty: .intermediate, annotations: [createAnnotation(title: "American Express", latitude: 44.463729193167694, longitude: -70.88240279639638, difficulty: .intermediate), createAnnotation(title: "3MLJunctionAE", latitude: 44.46749143347745, longitude: -70.87835840418714, difficulty: .intermediate), createAnnotation(title: "bend1AE", latitude: 44.46860516845412, longitude: -70.87626493580731, difficulty: .intermediate), createAnnotation(title: "LRJunctionAE", latitude: 44.469746572790164, longitude: -70.87096508865964, difficulty: .intermediate)]),
        Trail(name: "Risky Business", difficulty: .intermediate, annotations: [createAnnotation(title: "Risky Business", latitude: 44.46311714851905, longitude: -70.88223713245962, difficulty: .intermediate), createAnnotation(title: "bend1RB", latitude: 44.46403732360429, longitude: -70.879867409496, difficulty: .intermediate), createAnnotation(title: "bend2RB", latitude: 44.46633066617157, longitude: -70.87817420831703, difficulty: .intermediate), createAnnotation(title: "LRJunctionRB", latitude: 44.4675283503892, longitude: -70.87393140936513, difficulty: .intermediate)]),
        Trail(name: "Gnarnia", difficulty: .expertsOnly, annotations: [createAnnotation(title: "Gnarnia", latitude: 44.46504255184882, longitude: -70.87895361782995, difficulty: .expertsOnly), createAnnotation(title: "3MLJunctionGnarnia", latitude: 44.46591263745777, longitude: -70.87662346618372, difficulty: .expertsOnly), createAnnotation(title: "endGnarnia", latitude: 44.4670794114396, longitude: -70.87444062902327, difficulty: .expertsOnly)]),
        Trail(name: "Tourist Trap", difficulty: .intermediate, annotations: [createAnnotation(title: "Tourist Trap", latitude: 44.46966600600691, longitude: -70.86793455018984, difficulty: .intermediate), createAnnotation(title: "OHJunctionTT", latitude: 44.469923339149595, longitude: -70.8664134016417, difficulty: .intermediate), createAnnotation(title: "endTT", latitude: 44.4695232038773, longitude: -70.86444287724876, difficulty: .intermediate)])]
    
    static let jordanTrails = [
        Trail(name: "Lollapalooza", difficulty: .easy, annotations: [createAnnotation(title: "Lollapalooza", latitude: 44.462722133198504, longitude: -70.90801346676562, difficulty: .easy), createAnnotation(title: "Bend1Lolla", latitude: 44.46896537000713, longitude: -70.91051231074235, difficulty: .easy), createAnnotation(title: "Bend2Lolla", latitude: 44.47320361662942, longitude: -70.90307864281174, difficulty: .easy)]),
        //1
        Trail(name: "Excalibur", difficulty: .intermediate, annotations: [createAnnotation(title: "Excalibur", latitude: 44.4631862777165, longitude: -70.9075832927418, difficulty: .intermediate), createAnnotation(title: "bend1Excal", latitude: 44.46617465583206, longitude: -70.90667308737615, difficulty: .intermediate), createAnnotation(title: "midExcal", latitude: 44.46862888873153, longitude: -70.90326718886139, difficulty: .intermediate), createAnnotation(title: "botExcal", latitude: 44.47189010004125, longitude: -70.89631064496007, difficulty: .intermediate)]),
        //2
        Trail(name: "Rogue Angel", difficulty: .intermediate, annotations: [createAnnotation(title: "Rogue Angel", latitude: 44.46239298417106, longitude: -70.90692334506952, difficulty: .intermediate), createAnnotation(title: "MidRogue", latitude: 44.46633955610793, longitude: -70.90488744187293, difficulty: .intermediate), createAnnotation(title: "BotRogue", latitude: 44.470166735232745, longitude: -70.89713414576988, difficulty: .intermediate)]),
        //3
        Trail(name: "iCaramba!", difficulty: .expertsOnly, annotations: [createAnnotation(title: "iCaramba!", latitude: 44.463279337031715, longitude: -70.90610218702001, difficulty: .expertsOnly), createAnnotation(title: "botCaram", latitude: 44.46845226794425, longitude: -70.89911260345167, difficulty: .expertsOnly)]),
        //4
        Trail(name: "Kansas", difficulty: .easy, annotations: [createAnnotation(title: "Kansas", latitude: 44.46217702622463, longitude: -70.90716492905683, difficulty: .easy), createAnnotation(title: "bend1Kans", latitude: 44.4616778233863, longitude: -70.90722336991544, difficulty: .easy), createAnnotation(title: "ozJunctionKans", latitude: 44.46123534688093, longitude: -70.904483474769, difficulty: .easy), createAnnotation(title: "Tin Woodsman Junction of Kansasa", latitude: 44.460493480812396, longitude: -70.90366928411956, difficulty: .easy), createAnnotation(title: "bend2Kans", latitude: 44.460163849745214, longitude: -70.90148578576282, difficulty: .easy), createAnnotation(title: "bend3Kans", latitude: 44.46120348032429, longitude: -70.89721818116446, difficulty: .easy), createAnnotation(title: "bend4Kans", latitude: 44.461197797114906, longitude: -70.89514601904098, difficulty: .easy), createAnnotation(title: "endKans", latitude: 44.46460234637316, longitude: -70.89052023312101, difficulty: .easy)])]
    
    
    static let OzTrails : [Trail] = [
        Trail(name: "Tin Woodsman", difficulty: .expertsOnly, annotations: [createAnnotation(title: "Tin Woodsman", latitude: 44.46000309303237, longitude: -70.90520452974141, difficulty: .expertsOnly), createAnnotation(title: "Tin Woodsman", latitude: 44.460493480812396, longitude: -70.90366928411956, difficulty: .expertsOnly), createAnnotation(title: "endWoodsman", latitude: 44.46555178523853, longitude: -70.89955012783363, difficulty: .expertsOnly)])]
    
    static let AuroraTrails = [
        Trail(name: "Cyclone", difficulty: .easy, annotations: [createAnnotation(title: "Cyclone", latitude: 44.46456443017323, longitude: -70.88952523556077, difficulty: .easy), createAnnotation(title: "Cyclone", latitude: 44.46558362151272, longitude: -70.89119954539368, difficulty: .easy), createAnnotation(title: "Poppy Fields Junction of Cyclone", latitude: 44.465180155636666, longitude: -70.89860031454471, difficulty: .easy), createAnnotation(title: "Woodsman Junction of Cyclone", latitude: 44.46618881509814, longitude: -70.89898577127133, difficulty: .easy), createAnnotation(title: "iCaramba Junction of Cyclone", latitude: 44.468756233263775, longitude: -70.89862601165983, difficulty: .easy), createAnnotation(title: "Rogue Angel Junction of Cyclone", latitude: 44.47025995431891, longitude: -70.89703279052316, difficulty: .easy)]),
        //7
        Trail(name: "Northern Lights", difficulty: .intermediate, annotations: [createAnnotation(title: "Northern Lights", latitude: 44.463074702413536, longitude: -70.89016787184919, difficulty: .intermediate), createAnnotation(title: "witchWayNLJunction", latitude: 44.463381905172064, longitude: -70.89103146842714, difficulty: .intermediate), createAnnotation(title: "Northern Lights", latitude: 44.464494386806685, longitude: -70.89016611861871, difficulty: .intermediate), createAnnotation(title: "Cyclone Junction of Northern Lights", latitude: 44.46558362151272, longitude: -70.89119954539368, difficulty: .intermediate), createAnnotation(title: "Bend1NL", latitude: 44.46833930957292, longitude: -70.89052310618935, difficulty: .intermediate), createAnnotation(title: "fireStarJunction", latitude: 44.47011932648898, longitude: -70.88898936523161, difficulty: .intermediate)]),
        //8
        Trail(name: "Witch Way", difficulty: .intermediate, annotations: [createAnnotation(title: "Witch Way", latitude: 44.46331003750903, longitude: -70.89121983761352, difficulty: .intermediate), createAnnotation(title: "kansJunctionWitchWay", latitude: 44.463261798949524, longitude: -70.89272761114972, difficulty: .easy)]),
        //9
        Trail(name: "Airglow", difficulty: .advanced, annotations: [createAnnotation(title: "Airglow", latitude: 44.46295555779937, longitude: -70.88985528788332, difficulty: .advanced), createAnnotation(title: "Airglow", latitude: 44.46455484997939, longitude: -70.88938730025085, difficulty: .advanced), createAnnotation(title: "bend1Airglow", latitude: 44.46662949056471, longitude: -70.889916758492, difficulty: .advanced), createAnnotation(title: "blackHoleJunctionAirglow", latitude: 44.46796659263303, longitude: -70.88877674135661, difficulty: .advanced), createAnnotation(title: "bend2Airglow", latitude: 44.468647480083405, longitude: -70.88886118943041, difficulty: .advanced), createAnnotation(title: "botAirglow", latitude: 44.470649076580095, longitude: -70.88638637103126, difficulty: .advanced)]),
        //10
        Trail(name: "Black Hole", difficulty: .expertsOnly, annotations: [createAnnotation(title: "Blackhole", latitude: 44.46807563954452, longitude: -70.88849119199799, difficulty: .expertsOnly), createAnnotation(title: "botBlackHole", latitude: 44.468389612889254, longitude: -70.88751782797863, difficulty: .expertsOnly)]),
        //11
        Trail(name: "Fire Star", difficulty: .intermediate, annotations: [createAnnotation(title: "Firestar", latitude: 44.47027546367753, longitude: -70.8891562617633, difficulty: .intermediate), createAnnotation(title: "bend1Firestar", latitude: 44.47131672230162, longitude: -70.88964243473075, difficulty: .intermediate), createAnnotation(title: "bend2Firestar", latitude: 44.47067522787059, longitude: -70.89290882164136, difficulty: .intermediate), createAnnotation(title: "endFirestar", latitude: 44.47144966604338, longitude: -70.89408874939902, difficulty: .intermediate)]),
        //12
        Trail(name: "Lights Out", difficulty: .easy, annotations: [createAnnotation(title: "Lights Out", latitude: 44.46462524594242, longitude: -70.88910826784524, difficulty: .easy), createAnnotation(title: "Vortex Junction of Lights Out", latitude: 44.465846797045174, longitude: -70.88490523498776, difficulty: .easy), createAnnotation(title: "Upper Downdraft Junction of Lights Out", latitude: 44.466777506067146, longitude: -70.88153876394715, difficulty: .easy), createAnnotation(title: "endLightsOut", latitude: 44.46805596442271, longitude: -70.87977953790342, difficulty: .easy)]),
        //14
        Trail(name: "Borealis", difficulty: .easy, annotations: [createAnnotation(title: "Borealis", latitude: 44.46278170427937, longitude: -70.8895517763241, difficulty: .easy), createAnnotation(title: "bend1Borealis", latitude: 44.46248534478416, longitude: -70.88749443819064, difficulty: .easy), createAnnotation(title: "bend2Borealis", latitude: 44.4632449499215, longitude: -70.88551136371929, difficulty: .easy), createAnnotation(title: "vortexJunctionBorealis", latitude: 44.463909310290184, longitude: -70.88505530436773, difficulty: .easy), createAnnotation(title: "bend3Borealis", latitude: 44.46363692988425, longitude: -70.88602217785332, difficulty: .easy), createAnnotation(title: "endBorealis", latitude: 44.46456958036436, longitude: -70.88903941153798, difficulty: .easy)]),
        //15
        Trail(name: "Vortex", difficulty: .expertsOnly, annotations: [createAnnotation(title: "Vortex", latitude: 44.464086260411534, longitude: -70.88472455446858, difficulty: .expertsOnly), createAnnotation(title: "Vortex", latitude: 44.465875965885864, longitude: -70.88498076829377, difficulty: .expertsOnly), createAnnotation(title: "botVertex", latitude: 44.468935280601265, longitude: -70.88537258035753, difficulty: .expertsOnly)])]
    
    static let NorthPeakTrails = [
        //13
        Trail(name: "Paradigm", difficulty: .intermediate, annotations: [createAnnotation(title: "Paradigm", latitude: 44.46924157923843, longitude: -70.88073865336285, difficulty: .intermediate), createAnnotation(title: "bend1Paradigm", latitude: 44.4684834073092, longitude: -70.88413019219388, difficulty: .intermediate), createAnnotation(title: "Vortex Junction of Paradigm", latitude: 44.469151693786706, longitude: -70.88538404261011, difficulty: .intermediate), createAnnotation(title: "botParadigm", latitude: 44.4704364585831, longitude: -70.88622009554196, difficulty: .intermediate)]),
        //16
        Trail(name: "Second Mile", difficulty: .easy, annotations: [createAnnotation(title: "Second Mile", latitude: 44.46943702535925, longitude: -70.8789654647034, difficulty: .easy), createAnnotation(title: "Grand Rapids Junction of Second Mile", latitude: 44.47032406589279, longitude: -70.8781603365251, difficulty: .easy), createAnnotation(title: "Dream Maker Terrain Park Junction of Second Mile", latitude: 44.47088989413925, longitude: -70.87745792932414, difficulty: .easy), createAnnotation(title: "Escapade Junction of Second Mile", latitude: 44.471003653600654, longitude: -70.87608625181753, difficulty: .easy), createAnnotation(title: "3D Junction of Second Mile", latitude: 44.47182260784928, longitude: -70.87552946703043, difficulty: .easy), createAnnotation(title: "T72 Junction of Second Mile", latitude: 44.47240398079546, longitude: -70.87625359900291, difficulty: .easy), createAnnotation(title: "Dream Maker Junction of Second Mile", latitude: 44.472801490123636, longitude: -70.87674741037038, difficulty: .easy), createAnnotation(title: "endSM", latitude: 44.473345284763425, longitude: -70.87706137962822, difficulty: .easy)]),
        //17
        Trail(name: "Quantum Leap", difficulty: .expertsOnly, annotations: [createAnnotation(title: "Quantum Leap", latitude: 44.47035064728613, longitude: -70.88015704719764, difficulty: .expertsOnly), createAnnotation(title: "backsideJunctionQL", latitude: 44.47122504001555, longitude: -70.88101932258316, difficulty: .expertsOnly), createAnnotation(title: "bend1QL", latitude: 44.47168976730243, longitude: -70.8815677621026, difficulty: .expertsOnly), createAnnotation(title: "botQuantum", latitude: 44.47158096623986, longitude: -70.8846825390319, difficulty: .expertsOnly)]),
        //18
        Trail(name: "Grand Rapids", difficulty: .intermediate, annotations: [createAnnotation(title: "Grand Rapids", latitude: 44.469956233389304, longitude: -70.88004779413315, difficulty: .intermediate), createAnnotation(title: "Grand Rapids", latitude: 44.47031418756157, longitude: -70.87814112970221, difficulty: .intermediate), createAnnotation(title: "bend1GR", latitude: 44.46985270909712, longitude: -70.87704051030686, difficulty: .intermediate), createAnnotation(title: "Downdraft Junction of Grand Rapids", latitude: 44.47013967347965, longitude: -70.8751210217859, difficulty: .intermediate), createAnnotation(title: "bend2GR", latitude: 44.46988573312703, longitude: -70.87342068410626, difficulty: .intermediate), createAnnotation(title: "bend3GR", latitude: 44.470165629165166, longitude: -70.87145465636517, difficulty: .intermediate), createAnnotation(title: "lazyRiverJunction", latitude: 44.46994988535315, longitude: -70.87066371925623, difficulty: .intermediate), createAnnotation(title: "endGR", latitude: 44.469782541751115, longitude: -70.86966881640289, difficulty: .intermediate)]),
        //19
        Trail(name: "Lower Downdraft", difficulty: .intermediate, annotations: [createAnnotation(title: "LowerDowndraft", latitude: 44.46860992943861, longitude: -70.87879804629708, difficulty: .intermediate), createAnnotation(title: "GRJunctionLD", latitude: 44.46959736320973, longitude: -70.87530580117387, difficulty: .intermediate), createAnnotation(title: "AEJunctionLD", latitude: 44.46918178597036, longitude: -70.874023955678, difficulty: .intermediate)]),
        //20
        Trail(name: "Dream Maker", difficulty: .easy, annotations: [createAnnotation(title: "Dream Maker", latitude: 44.47041324409543, longitude: -70.87983797942842, difficulty: .easy), createAnnotation(title: "bend1DM", latitude: 44.47115946746551, longitude: -70.87910663287175, difficulty: .easy), createAnnotation(title: "TPJunctionDM", latitude: 44.47116183566172, longitude: -70.87818807321169, difficulty: .easy), createAnnotation(title: "Dream Maker", latitude: 44.47266041086979, longitude: -70.87677881029504, difficulty: .easy), createAnnotation(title: "Bend2DM", latitude: 44.47420077369788, longitude: -70.87533495049598, difficulty: .easy), createAnnotation(title: "Bend3DM", latitude: 44.47533196146996, longitude: -70.87194777471294, difficulty: .easy), createAnnotation(title: "Ridge Run Junction of Dream Maker", latitude: 44.47537671715984, longitude: -70.87087950264689, difficulty: .easy), createAnnotation(title: "T72JunctionDM", latitude: 44.47487871455419, longitude: -70.86698253348032, difficulty: .easy)]),
        //21
        Trail(name: "T72", difficulty: .terrainPark, annotations: [createAnnotation(title: "T72", latitude: 44.472471107753584, longitude: -70.87620738098036, difficulty: .terrainPark), createAnnotation(title: "lastMileJunctionT72", latitude: 44.47337872106561, longitude: -70.87490427324434, difficulty: .terrainPark), createAnnotation(title: "Ridge Run Junction of T72", latitude: 44.47453803470397, longitude: -70.87116281597753, difficulty: .terrainPark), createAnnotation(title: "endT72", latitude: 44.47473408882887, longitude: -70.86794362038924, difficulty: .terrainPark)]),
        //22
        Trail(name: "Sensation", difficulty: .easy, annotations: [createAnnotation(title: "Sensation", latitude: 44.47357411061319, longitude: -70.87714633484791, difficulty: .easy), createAnnotation(title: "bend1Sensation", latitude: 44.47383611957847, longitude: -70.87866777885614, difficulty: .easy), createAnnotation(title: "bend2Sensation", latitude: 44.473345120391464, longitude: -70.88219792471021, difficulty: .easy), createAnnotation(title: "bend3Sensation", latitude: 44.47295085342931, longitude: -70.88307854077962, difficulty: .easy), createAnnotation(title: "QLJunctionSensation", latitude: 44.47142563657733, longitude: -70.88504385707459, difficulty: .easy)]),
        //23
        Trail(name: "Dream Maker Terrain Park", difficulty: .terrainPark, annotations: [createAnnotation(title: "Dream Maker Terrain Park", latitude: 44.471098472385926, longitude: -70.87821486957192, difficulty: .terrainPark), createAnnotation(title: "botDMTP", latitude: 44.47093461371656, longitude: -70.87731104843927, difficulty: .terrainPark)]),
        //24
        Trail(name: "Escapade", difficulty: .intermediate, annotations: [createAnnotation(title: "Escapade", latitude: 44.470882935117665, longitude: -70.87588241388997, difficulty: .intermediate), createAnnotation(title: "bend1Escapade", latitude: 44.47042148619526, longitude: -70.87252464845587, difficulty: .intermediate), createAnnotation(title: "LMJunctionEscapade", latitude: 44.47141532781848, longitude: -70.87013850162772, difficulty: .intermediate)]),
        //25
        Trail(name: "3D", difficulty: .terrainPark, annotations: [createAnnotation(title: "3D", latitude: 44.47198060772869, longitude: -70.87525217806382, difficulty: .terrainPark), createAnnotation(title: "Last Mile Junction of 3D", latitude: 44.47277555409285, longitude: -70.87325638692266, difficulty: .terrainPark), createAnnotation(title: "Ridge Run Junction of 3D", latitude: 44.47357813833369, longitude: -70.87069873813503, difficulty: .terrainPark), createAnnotation(title: "bend13D", latitude: 44.47391397246592, longitude: -70.86865469996928, difficulty: .intermediate), createAnnotation(title: "bot3D", latitude: 44.474622082181334, longitude: -70.86708734917693, difficulty: .terrainPark)])]
    
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
    static let bend1SP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[1])
    static let bend2SP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[2])
    static let agonyJunctionSP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[3])
    static let LSP2JunctionSP = Vertex<ImageAnnotation>(barkerTrails[9].annotations[4])
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
    //Locke
    static let botLocke = Vertex<ImageAnnotation>(Lifts[9].annotations[0])
    static let topLocke = Vertex<ImageAnnotation>(Lifts[9].annotations[1])
    //Goat Path
    static let topGP = Vertex<ImageAnnotation>(lockeTrails[0].annotations[0])
    static let UCJunctionGP = Vertex<ImageAnnotation>(lockeTrails[0].annotations[1])
    static let JRJunctionGP = Vertex<ImageAnnotation>(lockeTrails[0].annotations[2])
    static let bend1GP = Vertex<ImageAnnotation>(lockeTrails[0].annotations[3])
    static let EcstasyJunctionGP = Vertex<ImageAnnotation>(lockeTrails[0].annotations[4])
    static let bend2GP = Vertex<ImageAnnotation>(lockeTrails[0].annotations[5])
    static let agonyJunctionGP = Vertex<ImageAnnotation>(lockeTrails[0].annotations[6])
    static let TGJunctionGP = Vertex<ImageAnnotation>(lockeTrails[0].annotations[7])
    static let LRJunctionGP = Vertex<ImageAnnotation>(lockeTrails[0].annotations[8])
    //Upper cut
    static let topUC = Vertex<ImageAnnotation>(lockeTrails[1].annotations[0])
    static let JRJunctionUC = Vertex<ImageAnnotation>(lockeTrails[1].annotations[1])
    static let bend1UC = Vertex<ImageAnnotation>(lockeTrails[1].annotations[2])
    static let ecstasyJunctionUC = Vertex<ImageAnnotation>(lockeTrails[1].annotations[3])
    //Upper Sunday Punch
    static let topUSP = Vertex<ImageAnnotation>(lockeTrails[2].annotations[0])
    static let JRJunctionUSP = Vertex<ImageAnnotation>(lockeTrails[2].annotations[1])
    static let bend1USP = Vertex<ImageAnnotation>(lockeTrails[2].annotations[2])
    static let bend2USP = Vertex<ImageAnnotation>(lockeTrails[2].annotations[3])
    static let LLUSP = Vertex<ImageAnnotation>(lockeTrails[2].annotations[4])
    static let bend3USP = Vertex<ImageAnnotation>(lockeTrails[2].annotations[5])
    static let GrandJunctionUSP = Vertex<ImageAnnotation>(lockeTrails[2].annotations[6])
    //Locke Line
    static let topLL = Vertex<ImageAnnotation>(lockeTrails[3].annotations[0])
    static let JWJunctionLL = Vertex<ImageAnnotation>(lockeTrails[3].annotations[1])
    static let USPJunctionLL = Vertex<ImageAnnotation>(lockeTrails[3].annotations[2])
    static let EcstasyLL = Vertex<ImageAnnotation>(lockeTrails[3].annotations[3])
    //Jim's Whim
    static let topJW = Vertex<ImageAnnotation>(lockeTrails[4].annotations[0])
    static let LLJunctionJW = Vertex<ImageAnnotation>(lockeTrails[4].annotations[1])
    static let T2JunctionJW = Vertex<ImageAnnotation>(lockeTrails[4].annotations[2])
    //T2
    static let topT2 = Vertex<ImageAnnotation>(lockeTrails[5].annotations[0])
    static let LLJunctionT2 = Vertex<ImageAnnotation>(lockeTrails[5].annotations[1])
    static let JWJunctionT2 = Vertex<ImageAnnotation>(lockeTrails[5].annotations[2])
    static let endT2 = Vertex<ImageAnnotation>(lockeTrails[5].annotations[3])
    //Bim's Whim
    static let topBW = Vertex<ImageAnnotation>(lockeTrails[6].annotations[0])
    static let bend1BW = Vertex<ImageAnnotation>(lockeTrails[6].annotations[1])
    static let bend2BW = Vertex<ImageAnnotation>(lockeTrails[6].annotations[2])
    static let bend3BW = Vertex<ImageAnnotation>(lockeTrails[6].annotations[3])
    static let bend4BW = Vertex<ImageAnnotation>(lockeTrails[6].annotations[4])
    static let bend5BW = Vertex<ImageAnnotation>(lockeTrails[6].annotations[5])
    static let salvationJunctionBW = Vertex<ImageAnnotation>(lockeTrails[6].annotations[6])
    static let WCJunctionBW = Vertex<ImageAnnotation>(lockeTrails[6].annotations[7])
    //Cascades
    static let topCC = Vertex<ImageAnnotation>(lockeTrails[7].annotations[0])
    static let SBJunctionCC = Vertex<ImageAnnotation>(lockeTrails[7].annotations[1])
    static let TempestJunctionCC = Vertex<ImageAnnotation>(lockeTrails[7].annotations[2])
    static let endCC = Vertex<ImageAnnotation>(lockeTrails[7].annotations[3])
    //Monday Mourning
    static let topMM = Vertex<ImageAnnotation>(lockeTrails[8].annotations[0])
    static let endMM = Vertex<ImageAnnotation>(lockeTrails[8].annotations[1])
    //Bear Paw
    static let topBP = Vertex<ImageAnnotation>(lockeTrails[9].annotations[0])
    static let bend1BP = Vertex<ImageAnnotation>(lockeTrails[9].annotations[1])
    static let bend2BP = Vertex<ImageAnnotation>(lockeTrails[9].annotations[2])
    static let bend3BP = Vertex<ImageAnnotation>(lockeTrails[9].annotations[3])
    static let bend4BP = Vertex<ImageAnnotation>(lockeTrails[9].annotations[4])
    static let bend5BP = Vertex<ImageAnnotation>(lockeTrails[9].annotations[5])
    static let COJunctionBP = Vertex<ImageAnnotation>(lockeTrails[9].annotations[6])
    static let endCOJunctionBP = Vertex<ImageAnnotation>(lockeTrails[9].annotations[7])
    static let bend6BP = Vertex<ImageAnnotation>(lockeTrails[9].annotations[8])
    static let endBP = Vertex<ImageAnnotation>(lockeTrails[9].annotations[9])
    //Wildfire
    static let topWF = Vertex<ImageAnnotation>(lockeTrails[10].annotations[0])
    static let bend1WF = Vertex<ImageAnnotation>(lockeTrails[10].annotations[1])
    static let COJunctionWF = Vertex<ImageAnnotation>(lockeTrails[10].annotations[2])
    static let CBJunctionWF = Vertex<ImageAnnotation>(lockeTrails[10].annotations[3])
    static let endWF = Vertex<ImageAnnotation>(lockeTrails[10].annotations[4])
    //Cut Off
    static let topCO = Vertex<ImageAnnotation>(lockeTrails[11].annotations[0])
    static let endCO = Vertex<ImageAnnotation>(lockeTrails[11].annotations[1])
    //Cut Back
    static let topCB = Vertex<ImageAnnotation>(lockeTrails[12].annotations[0])
    //Road Runner
    static let topRR = Vertex<ImageAnnotation>(lockeTrails[13].annotations[0])
    static let WFJunctionRoadR = Vertex<ImageAnnotation>(lockeTrails[13].annotations[1])
    static let bend1RoadR = Vertex<ImageAnnotation>(lockeTrails[13].annotations[2])
    static let bend2RoadR = Vertex<ImageAnnotation>(lockeTrails[13].annotations[3])
    static let endRoadR = Vertex<ImageAnnotation>(lockeTrails[13].annotations[4])
    //Snowbound
    static let topSB = Vertex<ImageAnnotation>(lockeTrails[14].annotations[0])
    static let endSB = Vertex<ImageAnnotation>(lockeTrails[14].annotations[1])
    //Tempest Quad
    static let botTQ = Vertex<ImageAnnotation>(Lifts[10].annotations[0])
    static let topTQ = Vertex<ImageAnnotation>(Lifts[10].annotations[1])
    //White Heat Quad
    static let botWHQ = Vertex<ImageAnnotation>(Lifts[12].annotations[0])
    static let topWHQ = Vertex<ImageAnnotation>(Lifts[12].annotations[1])
    //Salvation
    static let topSalvation = Vertex<ImageAnnotation>(whiteCapTrails[0].annotations[0])
    static let BWJunctionSalvation = Vertex<ImageAnnotation>(whiteCapTrails[0].annotations[1])
    static let bend1Salvation = Vertex<ImageAnnotation>(whiteCapTrails[0].annotations[2])
    static let BW2JunctionSalvation = Vertex<ImageAnnotation>(whiteCapTrails[0].annotations[3])
    static let HOJunctionSalvation = Vertex<ImageAnnotation>(whiteCapTrails[0].annotations[4])
    //Heat's Off
    static let topHO = Vertex<ImageAnnotation>(whiteCapTrails[1].annotations[0])
    static let endHO = Vertex<ImageAnnotation>(whiteCapTrails[1].annotations[1])
    //Obsession
    static let topObsession = Vertex<ImageAnnotation>(whiteCapTrails[2].annotations[0])
    static let bend1Obsession = Vertex<ImageAnnotation>(whiteCapTrails[2].annotations[1])
    static let HOJunctionObsession = Vertex<ImageAnnotation>(whiteCapTrails[2].annotations[2])
    static let SBJunctionObsession = Vertex<ImageAnnotation>(whiteCapTrails[2].annotations[3])
    static let bend2Obsession = Vertex<ImageAnnotation>(whiteCapTrails[2].annotations[4])
    static let HOnJunctionObsession = Vertex<ImageAnnotation>(whiteCapTrails[2].annotations[5])
    //Chutzpah
    static let topChutzpah = Vertex<ImageAnnotation>(whiteCapTrails[3].annotations[0])
    static let midChutzpah = Vertex<ImageAnnotation>(whiteCapTrails[3].annotations[1])
    static let endChutzpah = Vertex<ImageAnnotation>(whiteCapTrails[3].annotations[2])
    //White Heat
    static let topWH = Vertex<ImageAnnotation>(whiteCapTrails[4].annotations[0])
    static let chutzpahJunctionWH = Vertex<ImageAnnotation>(whiteCapTrails[4].annotations[1])
    static let assumptionJunctionWH = Vertex<ImageAnnotation>(whiteCapTrails[4].annotations[2])
    //Shock Wave
    static let topSW = Vertex<ImageAnnotation>(whiteCapTrails[5].annotations[0])
    static let bend1SW = Vertex<ImageAnnotation>(whiteCapTrails[5].annotations[1])
    static let bend2SW = Vertex<ImageAnnotation>(whiteCapTrails[5].annotations[2])
    static let assumptionJunctionSW = Vertex<ImageAnnotation>(whiteCapTrails[5].annotations[3])
    //Tempest
    static let topTempest = Vertex<ImageAnnotation>(whiteCapTrails[6].annotations[0])
    static let HOJunctionTempest = Vertex<ImageAnnotation>(whiteCapTrails[6].annotations[1])
    static let endTempest = Vertex<ImageAnnotation>(whiteCapTrails[6].annotations[2])
    //Jibe
    static let topJibe = Vertex<ImageAnnotation>(whiteCapTrails[7].annotations[0])
    static let bend1Jibe = Vertex<ImageAnnotation>(whiteCapTrails[7].annotations[1])
    static let endJibe = Vertex<ImageAnnotation>(whiteCapTrails[7].annotations[2])
    //Heat's On
    static let topHON = Vertex<ImageAnnotation>(whiteCapTrails[8].annotations[0])
    static let obsessionJunctionHON = Vertex<ImageAnnotation>(whiteCapTrails[8].annotations[1])
    static let assumptionJunctionHON = Vertex<ImageAnnotation>(whiteCapTrails[8].annotations[2])
    static let SLJunctionHON = Vertex<ImageAnnotation>(whiteCapTrails[8].annotations[3])
    //Green Cheese
    static let topGC = Vertex<ImageAnnotation>(whiteCapTrails[9].annotations[0])
    static let SBJunctionGC = Vertex<ImageAnnotation>(whiteCapTrails[9].annotations[0])
    static let endGC = Vertex<ImageAnnotation>(whiteCapTrails[9].annotations[0])
    //Moonstruck
    static let topMS = Vertex<ImageAnnotation>(whiteCapTrails[10].annotations[0])
    static let bend1MS = Vertex<ImageAnnotation>(whiteCapTrails[10].annotations[1])
    static let bend2MS = Vertex<ImageAnnotation>(whiteCapTrails[10].annotations[2])
    static let bend3MS = Vertex<ImageAnnotation>(whiteCapTrails[10].annotations[3])
    static let GCJunctionMS = Vertex<ImageAnnotation>(whiteCapTrails[10].annotations[4])
    static let bend4MS = Vertex<ImageAnnotation>(whiteCapTrails[10].annotations[5])
    static let SBJunctionMS = Vertex<ImageAnnotation>(whiteCapTrails[10].annotations[6])
    static let SLJunctionMS = Vertex<ImageAnnotation>(whiteCapTrails[10].annotations[7])
    static let endMS = Vertex<ImageAnnotation>(whiteCapTrails[10].annotations[8])
    //Assumption
    static let topAssumption = Vertex<ImageAnnotation>(whiteCapTrails[11].annotations[0])
    static let SWJunctionAssumption = Vertex<ImageAnnotation>(whiteCapTrails[11].annotations[1])
    static let WHJunctionAssumption = Vertex<ImageAnnotation>(whiteCapTrails[11].annotations[2])
    static let WHQJunctionAssumption = Vertex<ImageAnnotation>(whiteCapTrails[11].annotations[3])
    //Starlight
    static let topSL = Vertex<ImageAnnotation>(whiteCapTrails[12].annotations[0])
    static let bend1SL = Vertex<ImageAnnotation>(whiteCapTrails[12].annotations[1])
    static let bend2SL = Vertex<ImageAnnotation>(whiteCapTrails[12].annotations[2])
    static let bend3SL = Vertex<ImageAnnotation>(whiteCapTrails[12].annotations[3])
    static let HOJunctionSL = Vertex<ImageAnnotation>(whiteCapTrails[12].annotations[4])
    static let MSJunctionSL = Vertex<ImageAnnotation>(whiteCapTrails[12].annotations[5])
    //Starstruck
    static let topSS = Vertex<ImageAnnotation>(whiteCapTrails[13].annotations[0])
    static let endSS = Vertex<ImageAnnotation>(whiteCapTrails[13].annotations[1])
    //Starwood
    static let topStarW = Vertex<ImageAnnotation>(whiteCapTrails[14].annotations[0])
    static let endStarW = Vertex<ImageAnnotation>(whiteCapTrails[14].annotations[1])
    //Starburst
    static let topStarB = Vertex<ImageAnnotation>(whiteCapTrails[15].annotations[0])
    static let GCJunctionSB = Vertex<ImageAnnotation>(whiteCapTrails[15].annotations[1])
    static let endStarB = Vertex<ImageAnnotation>(whiteCapTrails[15].annotations[2])
    //Little White Cap Quad
    static let botLWCQ = Vertex<ImageAnnotation>(Lifts[12].annotations[0])
    static let topLWCQ = Vertex<ImageAnnotation>(Lifts[12].annotations[1])

    static let keyAnnotations = [botSpruce, botQLT, botNP, botChondola, auroraSideJD, jordanSideJD, botAurora, botJord, topLol, topExcal, topRogue, topCaram, topKans, junctionWoodsman, topCyclone, northernLightsJunctionCyclone, kansasNLJunction, witchWayTop, cycloneJunctionAirglow, topBlackHole, topFirestar, startLO, topBorealis, kansasJunctionVortex, topParadigm, startSM, SMJunctionGR, topQuantum, topGR, topLD, topDM, Bend2DM, topT72, topSensation, topDMTP, topEscapade, top3D, botBarker, start3ML, startLR, startSluice, topRS, topAgony, topTG, topEcstasy, startJR, topLUC, topSP, topLSP, topRC, topTW, botSouthridge, startRR, topLE, topBroadway, topLLR, startThataway, topMB, topLCL, topWV, topWL, topNW, topSpectator, topDD, topSD, topST, topER, topEL, topSirius, topDowndraft, topAE, topRB, topGnarnia, topTT, botLocke, topGP, topUC, topUSP, topLL, topJW, topT2, topBW, topCC, topMM, topBP, topWF, topCO, topCB, topRR, topSB, botTQ, botWHQ, botLWCQ, topSalvation, topObsession, topChutzpah, topWH, topSW, topTempest, topJibe, topHON, topGC, topMS, topAssumption, topSL, topSS, topStarW, topStarB, botLWCQ]
    
    static let jordanKeyAnnotations = [botJord, topLol, topRogue, topExcal, topCaram, jordanSideJD]
    
    static let auroraKeyAnnotations = [botAurora, botQLT, topBorealis, topCyclone, northernLightsJunctionCyclone, kansasNLJunction, kansasJunctionVortex, startLO, topFirestar, topBlackHole, cycloneJunctionAirglow, witchWayTop]
    
    static let northPeakKeyAnnotations = [botNP, topParadigm, startSM, topEscapade, top3D, topSensation, topDM, topLD, topGR, topQuantum]
    
    static let barkerKeyAnnotations = [botBarker, start3ML, startLR, startSluice, topRS, topAgony, topTG, topEcstasy, startJR, topLUC, topSP, topLSP, topRC, topTW]
    
    static let southRidgeKeyAnnotations = [botSouthridge, botChondola, startRR, topLE, topBroadway, topLLR, startThataway, topMB, topLCL, topWV, topWL, topNW, topSpectator, topDD, topSD, topST, topER, topEL]
    
    static let spruceKeyAnnotations = [botSpruce, topSirius, topDowndraft, topAE, topRB, topGnarnia, topTT]
    
    static let lockeKeyAnnotations = [topGP, topUC, topUSP, topLL, topJW, topT2, topBW, topCC, topMM, topBP, topWF, topCO, topCB, topRR, topSB]
    
    static let whiteCapKeyAnnotations = [topSalvation, topHO, topObsession, topChutzpah, topWH, topStarW, topTempest, topJibe, topHON, topGC, topMS, topAssumption, topSL, topSS, topStarW, topSB]
    
    static let annotations = [botSpruce, topSpruce, botQLT, topQLT, botNP, topNP, botChondola, topChondola, auroraSideJD, jordanSideJD, botAurora, topAurora, botJord, topJord,  botLWCQ, topLWCQ, topLol, bend1Lol, bend2Lol, topExcal, bend1Excal, midExcal, botExcal, topRogue, midRogue, botRogue, topCaram, botCaram, topKans, bend1Kans, ozJunctionKans, woodsmanJunctionKans, bend2Kans, bend3Kans, bend4Kans, endKans, topWoodsman, junctionWoodsman, endWoodsman, topCyclone, northernLightsJunctionCyclone, poppyFieldsJunctionCyclone, woodsmanJunctionCyclone, carambaJunctionCyclone, rogueAngelJunctionCyclone, northernLightsTop, witchWayJunctionNL, kansasNLJunction, cycloneJunctionNL, bend1NL, fireStarJunctionNL, witchWayTop, kansJunctionWitchWay, topAirglow, cycloneJunctionAirglow, bend1Airglow, blackHoleJunctionAirglow, bend2Airglow, botAirglow, topBlackHole, botBlackHole, topFirestar, bend1Firestar, bend2Firestar, endFirestar, topBorealis, bend1Borealis, bend2Borealis, vortexJunctionBorealis,bend3Borealis, endBorealis, topVortex, kansasJunctionVortex, botVortex, topParadigm, bend1Paradigm, vortexJunctionParadigm, botParadigm, startSM, GRJunctionSM, DMTerrainJunctionSM, escapadeJunctionSM, ThreeDJunctionSM, T72JunctionSM, DMJunctionSM, endSM, topQuantum, backsideJunctionQL, bend1QL, botQuantum, topGR, SMJunctionGR, bend1GR, downdraftJunctionGR, bend2GR, bend3GR, lazyRiverJunctionGR, endGR, topLD, GRJunctionLD, AEJunctionLD, topDM, bend1DM, bend1GP, TPJunctionDM, Bend2DM, Bend3DM, RRJunctionDM, T72JunctionDM, topT72, lastMileJunctionT72, RRJunctionT72, endT72, topSensation, bend1Sensation, bend2Sensation, bend3Sensation, QLJunctionSensation, topDMTP, botDMTP, topEscapade, bend1Escapade, LMJunctionEscapade, top3D, LMJunction3D, RRJunction3D, bend13D, bot3D, startLO, vortexJunctionLO, UpperDownDraftJunctionLO, endLightsOut, botBarker, topBarker, start3ML, bend13ML, sluiceJunction3ML, gnarniaJunction3ML, RBJunction3ML, AEJunction3ML, bend23ML, bend33ML, end3ML, startLR, bend1LR, ThreeMLJunctionLR, bend2LR, bend3LR, bend4LR, sluiceJunctionLR, gnarniaJunctionLR, RBJunctionLR, bend5LR, AEJunctionLR, GRJunctionLR, endLR, startSluice, bend1Sluice, endSluice, topRS, bend1RS, bend2RS, bend3RS, LSPJunctionRS, topAgony, TGJunctionAgony, endAgony, topTG, bend1TG, LSPJunctionTG, topEcstasy, bend1Ecstasy, bend2Ecstasy, southPawEcstasy, uppercutJunctionEcstasy, startJR, bend1JR, bend2JR, GPJunctionJR, USPJunctionJR, topSP, bend1SP, bend2SP, agonyJunctionSP, LSP2JunctionSP, topLUC, botLUC, topLSP, SPJunctionuLSP, bend1LSP, SPRCJunctionLSP, TGJunctionLSP, RSJunctionLSP, TTJunctionLSP, endLSP, topRC, bend1RC, endRC, topTW, bend1TW, RCJunctionTW, botSouthridge, topSouthridge, startRR, EFJunctionRR, TDJunctionRR, bend1RR, T72JunctionRR, DMJunctionRR, STJunctionRR, LCJunctionRR, bend2RR, bend3RR, bend4RR, bend5RR, bend6RR, endRR, topLE, broadwayJunctionLE, NWJunctionLE, endLE, topBroadway, NWJunctionBroadway, MBJunctionBroadway, WVJunctionBroadway, WLJunctionBroadway, endBroadway, topLLR, bend1LLR, broadwayJunctionLLR, endLLR, startThataway, endThataway, topMB, bend1MB, endMB, topLCL, endLCL, topWV, endWV, topWL, endWL, topNW, LEJunctionNW, EFJunctionNW, endNW, topSpectator, sundanceJunctionSpectator, endSpectator, topDD, DMJunctionDD, endDD, topSD, DDSPRJunctionSD, DMJunctionSD, bend1SD, botSD, topST, bend1ST, endST, topER, endER, topEL, endEL, topSirius, endSirius, topDowndraft, endDowndraft, topAE, TMLJunctionAE, bend1AE, LRJunctionAE, topRB, bend1RB, bend2RB, LRJunctionRB, topGnarnia, TMLJunctionGnarnia, endGnarnia, topTT, OHJunctionTT, endTT, botLocke, topLocke, topGP, UCJunctionGP, JRJunctionGP, EcstasyJunctionGP, bend2GP, agonyJunctionGP, TGJunctionGP, LRJunctionGP, topUC, JRJunctionUC, bend1UC, ecstasyJunctionUC, topUSP, JRJunctionUSP, bend1USP, bend2USP, LLUSP, bend3USP, GrandJunctionUSP, topLL, JWJunctionLL, T2JunctionJW, topT2, LLJunctionT2, JWJunctionT2, endT2, LLJunctionJW, T2JunctionJW, topBW, bend1BW, bend2BW, bend3BW, bend4BW, bend5BW, salvationJunctionBW, WCJunctionBW, topCC, SBJunctionCC, TempestJunctionCC, endCC, topMM, endMM, topBP, bend1BP, bend2BP, bend3BP, bend4BP, bend5BP, COJunctionBP, endCOJunctionBP, bend6BP, endBP, topWF, bend1WF, COJunctionWF, CBJunctionWF, endWF, topCO, endCO, topCB, topRR, WFJunctionRoadR, bend1RoadR, bend2RoadR, endRoadR, topSB, endSB, botTQ, topTQ, botWHQ, topWHQ, topSalvation, BWJunctionSalvation, bend1Salvation, BWJunctionSalvation, bend1Salvation, BW2JunctionSalvation, HOJunctionSalvation, topHO, endHO, topObsession, bend1Obsession, HOJunctionObsession, SBJunctionObsession, bend2Obsession, HOnJunctionObsession, topChutzpah, midChutzpah, endChutzpah, topWH, chutzpahJunctionWH, assumptionJunctionWH, topSW, bend1SW, bend2SW, assumptionJunctionSW, topTempest, HOJunctionTempest, endTempest, topJibe, bend1Jibe, endJibe, topHON, obsessionJunctionHON, assumptionJunctionHON, SLJunctionHON, topGC, SBJunctionCC, endGC, topMS, bend1MS, bend2MS, bend3MS, GCJunctionMS, bend4MS, SBJunctionMS, SLJunctionMS, endMS, topAssumption, SWJunctionAssumption, WHJunctionAssumption, WHQJunctionAssumption, topSL, bend1SL, bend2SL, bend3SL, HOJunctionSL, MSJunctionSL, topSS, endSS, topStarW, endStarW, topStarB, GCJunctionSB, endStarB]
    
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
        graph.addEdge(direction: .undirected, from: botBarker, to: botLocke, weight: 100)
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
        graph.addEdge(direction: .directed, from: topRS, to: LRJunctionGP, weight: 300)
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
        graph.addEdge(direction: .directed, from: bend1Ecstasy, to: bend1GP, weight: 50)
        graph.addEdge(direction: .directed, from: bend1GP, to: bend2Ecstasy, weight: 50)
        graph.addEdge(direction: .directed, from: bend2Ecstasy, to: southPawEcstasy, weight: 50)
        graph.addEdge(direction: .directed, from: southPawEcstasy, to: uppercutJunctionEcstasy, weight: 50)
        graph.addEdge(direction: .directed, from: uppercutJunctionEcstasy, to: GrandJunctionUSP, weight: 50)
        //Jungle Road
        graph.addEdge(direction: .undirected, from: startJR, to: topBarker, weight: 1)
        graph.addEdge(direction: .directed, from: startJR, to: bend1JR, weight: 50)
        graph.addEdge(direction: .directed, from: bend1JR, to: bend2JR, weight: 50)
        graph.addEdge(direction: .directed, from: bend2JR, to: GPJunctionJR, weight: 50)
        graph.addEdge(direction: .directed, from: GPJunctionJR, to: JRJunctionUC, weight: 50)
        //Lower Upper Cut
        graph.addEdge(direction: .undirected, from: southPawEcstasy, to: topLUC, weight: 1)
        graph.addEdge(direction: .directed, from: topLUC, to: botLUC, weight: 50)
        graph.addEdge(direction: .directed, from: botLUC, to: topSP, weight: 50)
        graph.addEdge(direction: .directed, from: botLUC, to: SPJunctionuLSP, weight: 50)
        //South Paw
        graph.addEdge(direction: .directed, from: topSP, to: bend1SP, weight: 50)
        graph.addEdge(direction: .directed, from: bend1SP, to: bend2SP, weight: 50)
        graph.addEdge(direction: .directed, from: bend2SP, to: agonyJunctionSP, weight: 50)
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
        graph.addEdge(direction: .undirected, from: endLSP, to: endRC, weight: 1)
        //Rocking Chair
        graph.addEdge(direction: .directed, from: topRC, to: bend1RC, weight: 50)
        graph.addEdge(direction: .directed, from: bend1RC, to: endRC, weight: 50)
        graph.addEdge(direction: .directed, from: endRC, to: botBarker, weight: 50)
        graph.addEdge(direction: .undirected, from: endRC, to: botLocke, weight: 1)
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
        //Locke Triple
        graph.addEdge(direction: .directed, from: botLocke, to: topLocke, weight: 100)
        //Goat Path
        graph.addEdge(direction: .undirected, from: topUSP, to: topGP, weight: 1)
        graph.addEdge(direction: .directed, from: topGP, to: UCJunctionGP, weight: 50)
        graph.addEdge(direction: .directed, from: UCJunctionGP, to: JRJunctionGP, weight: 50)
        graph.addEdge(direction: .undirected, from: JRJunctionGP, to: GPJunctionJR, weight: 1)
        graph.addEdge(direction: .directed, from: JRJunctionGP, to: bend1GP, weight: 50)
        graph.addEdge(direction: .undirected, from: bend1GP, to: EcstasyJunctionGP, weight: 50)
        graph.addEdge(direction: .directed, from: bend1GP, to: bend2Ecstasy, weight: 50)
        graph.addEdge(direction: .directed, from: EcstasyJunctionGP, to: bend2GP, weight: 50)
        graph.addEdge(direction: .directed, from: bend2GP, to: agonyJunctionGP, weight: 50)
        graph.addEdge(direction: .undirected, from: TGJunctionAgony, to: agonyJunctionGP, weight: 1)
        graph.addEdge(direction: .directed, from: agonyJunctionGP, to: TGJunctionGP, weight: 50)
        graph.addEdge(direction: .undirected, from: TGJunctionGP, to: bend1TG, weight: 1)
        graph.addEdge(direction: .directed, from: TGJunctionGP, to: LRJunctionGP, weight: 50)
        graph.addEdge(direction: .directed, from: LRJunctionGP, to: bend1RS, weight: 50)
        //Upper Cut
        graph.addEdge(direction: .undirected, from: UCJunctionGP, to: topUC, weight: 1)
        graph.addEdge(direction: .directed, from: topUC, to: JRJunctionUC, weight: 300)
        graph.addEdge(direction: .undirected, from: JRJunctionUC, to: USPJunctionJR, weight: 1)
        graph.addEdge(direction: .directed, from: JRJunctionUC, to: bend1UC, weight: 300)
        graph.addEdge(direction: .directed, from: bend1UC, to: ecstasyJunctionUC, weight: 300)
        graph.addEdge(direction: .directed, from: ecstasyJunctionUC, to: bend2Ecstasy, weight: 50)
        //Upper Sunday Punch
        graph.addEdge(direction: .directed, from: topLocke, to: topUSP, weight: 50)
        graph.addEdge(direction: .directed, from: topUSP, to: JRJunctionUSP, weight: 50)
        graph.addEdge(direction: .undirected, from: JRJunctionUSP, to: USPJunctionJR, weight: 1)
        graph.addEdge(direction: .directed, from: JRJunctionUSP, to: bend1USP, weight: 50)
        graph.addEdge(direction: .directed, from: bend1USP, to: bend2USP, weight: 50)
        graph.addEdge(direction: .directed, from: bend2USP, to: LLUSP, weight: 50)
        graph.addEdge(direction: .undirected, from: LLUSP, to: USPJunctionLL, weight: 1)
        graph.addEdge(direction: .directed, from: LLUSP, to: bend3USP, weight: 50)
        graph.addEdge(direction: .directed, from: bend3USP, to: GrandJunctionUSP, weight: 50)
        graph.addEdge(direction: .directed, from: GrandJunctionUSP, to: topLSP, weight: 50)
        //Locke Line
        graph.addEdge(direction: .undirected, from: LLJunctionT2, to: topLL, weight: 1)
        graph.addEdge(direction: .directed, from: topLL, to: JWJunctionLL, weight: 300)
        graph.addEdge(direction: .undirected, from: JWJunctionLL, to: LLJunctionJW, weight: 1)
        graph.addEdge(direction: .directed, from: JWJunctionLL, to: USPJunctionLL, weight: 300)
        graph.addEdge(direction: .undirected, from: USPJunctionLL, to: LLUSP, weight: 1)
        //Jim's Whim
        graph.addEdge(direction: .undirected, from: USPJunctionJR, to: topJW, weight: 1)
        graph.addEdge(direction: .directed, from: topJW, to: LLJunctionJW, weight: 300)
        graph.addEdge(direction: .directed, from: LLJunctionJW, to: T2JunctionJW, weight: 300)
        //T2
        graph.addEdge(direction: .undirected, from: topLocke, to: topT2, weight: 1)
        graph.addEdge(direction: .directed, from: topT2, to: LLJunctionT2, weight: 300)
        graph.addEdge(direction: .directed, from: LLJunctionT2, to: JWJunctionT2, weight: 300)
        graph.addEdge(direction: .directed, from: JWJunctionT2, to: endT2, weight: 300)
        //Bim's Whim
        graph.addEdge(direction: .undirected, from: topLocke, to: topBW, weight: 1)
        graph.addEdge(direction: .directed, from: topBW, to: bend1BW, weight: 300)
        graph.addEdge(direction: .directed, from: bend1BW, to: bend2BW, weight: 300)
        graph.addEdge(direction: .directed, from: bend2BW, to: bend3BW, weight: 300)
        graph.addEdge(direction: .directed, from: bend3BW, to: bend4BW, weight: 300)
        graph.addEdge(direction: .directed, from: bend4BW, to: bend5BW, weight: 300)
        graph.addEdge(direction: .directed, from: bend5BW, to: WCJunctionBW, weight: 300)
        graph.addEdge(direction: .undirected, from: topWHQ, to: WCJunctionBW, weight: 300)
        graph.addEdge(direction: .directed, from: bend5BW, to: salvationJunctionBW, weight: 300)
        graph.addEdge(direction: .undirected, from: salvationJunctionBW, to: BWJunctionSalvation, weight: 1)
        //Cascades
        graph.addEdge(direction: .directed, from: GrandJunctionUSP, to: topCC, weight: 50)
        graph.addEdge(direction: .directed, from: topCC, to: endHO, weight: 50)
        graph.addEdge(direction: .directed, from: endHO, to: SBJunctionCC, weight: 50)
        graph.addEdge(direction: .directed, from: SBJunctionCC, to: topTQ, weight: 50)
        graph.addEdge(direction: .directed, from: topTQ, to: TempestJunctionCC, weight: 50)
        graph.addEdge(direction: .directed, from: SBJunctionCC, to: TempestJunctionCC, weight: 50)
        graph.addEdge(direction: .directed, from: TempestJunctionCC, to: endCC, weight: 50)
        graph.addEdge(direction: .directed, from: endCC, to: topRR, weight: 50)
        graph.addEdge(direction: .directed, from: endCC, to: botLocke, weight: 50)
        //Monday Mourning
        graph.addEdge(direction: .directed, from: GrandJunctionUSP, to: topMM, weight: 50)
        graph.addEdge(direction: .directed, from: endT2, to: topMM, weight: 300)
        graph.addEdge(direction: .directed, from: topMM, to: endMM, weight: 300)
        graph.addEdge(direction: .directed, from: endMM, to: topRR, weight: 300)
        graph.addEdge(direction: .directed, from: endMM, to: endRC, weight: 300)
        //Bear Paw
        graph.addEdge(direction: .undirected, from: topTQ, to: topBP, weight: 1)
        graph.addEdge(direction: .undirected, from: topBP, to: topWF, weight: 1)
        graph.addEdge(direction: .directed, from: topBP, to: topTempest, weight: 1)
        graph.addEdge(direction: .directed, from: topBP, to: bend1BP, weight: 1)
        graph.addEdge(direction: .directed, from: bend1BP, to: bend2BP, weight: 1)
        graph.addEdge(direction: .directed, from: bend2BP, to: bend3BP, weight: 1)
        graph.addEdge(direction: .directed, from: bend3BP, to: bend4BP, weight: 1)
        graph.addEdge(direction: .directed, from: bend4BP, to: bend5BP, weight: 1)
        graph.addEdge(direction: .directed, from: bend5BP, to: COJunctionBP, weight: 1)
        graph.addEdge(direction: .directed, from: COJunctionBP, to: endCOJunctionBP, weight: 1)
        graph.addEdge(direction: .undirected, from: endCOJunctionBP, to: endCO, weight: 1)
        graph.addEdge(direction: .directed, from: endCOJunctionBP, to: bend6BP, weight: 1)
        graph.addEdge(direction: .directed, from: bend6BP, to: endBP, weight: 1)
        graph.addEdge(direction: .directed, from: endBP, to: topRR, weight: 1)
        graph.addEdge(direction: .directed, from: endBP, to: botLocke, weight: 1)
        //Wildfire
        graph.addEdge(direction: .directed, from: topWF, to: bend1WF, weight: 50)
        graph.addEdge(direction: .directed, from: bend1WF, to: COJunctionWF, weight: 50)
        graph.addEdge(direction: .directed, from: COJunctionWF, to: CBJunctionWF, weight: 50)
        graph.addEdge(direction: .directed, from: CBJunctionWF, to: endWF, weight: 50)
        graph.addEdge(direction: .undirected, from: endWF, to: WFJunctionRoadR, weight: 1)
        //Cut Off
        graph.addEdge(direction: .undirected, from: COJunctionWF, to: topCO, weight: 1)
        graph.addEdge(direction: .undirected, from: topCO, to: COJunctionBP, weight: 1)
        graph.addEdge(direction: .directed, from: endCO, to: endCC, weight: 50)
        //Cut Back
        graph.addEdge(direction: .undirected, from: CBJunctionWF, to: topCB, weight: 1)
        graph.addEdge(direction: .undirected, from: topCB, to: bend6BP, weight: 1)
        //Road Runner
        graph.addEdge(direction: .directed, from: botLocke, to: topRR, weight: 1)
        graph.addEdge(direction: .directed, from: topRR, to: WFJunctionRoadR, weight: 1)
        graph.addEdge(direction: .directed, from: WFJunctionRoadR, to: bend1RoadR, weight: 1)
        graph.addEdge(direction: .directed, from: bend1RoadR, to: bend2RoadR, weight: 1)
        graph.addEdge(direction: .directed, from: bend2RoadR, to: endRoadR, weight: 1)
        graph.addEdge(direction: .undirected, from: endRoadR, to: botTQ, weight: 1)
        graph.addEdge(direction: .undirected, from: endRoadR, to: botLWCQ, weight: 1)
        //Snowbound
        graph.addEdge(direction: .undirected, from: SBJunctionCC, to: topSB, weight: 1)
        graph.addEdge(direction: .directed, from: topSB, to: endSB, weight: 300)
        graph.addEdge(direction: .undirected, from: endSB, to: SBJunctionObsession, weight: 300)
        //Tempest Quad
        graph.addEdge(direction: .directed, from: botTQ, to: topTQ, weight: 100)
        graph.addEdge(direction: .undirected, from: botTQ, to: botLWCQ, weight: 1)
        //White heat Quad
        graph.addEdge(direction: .directed, from: botWHQ, to: topWHQ, weight: 100)
        //Salvation
        graph.addEdge(direction: .undirected, from: topWHQ, to: topSalvation, weight: 1)
        graph.addEdge(direction: .directed, from: topSalvation, to: BWJunctionSalvation, weight: 50)
        graph.addEdge(direction: .directed, from: BWJunctionSalvation, to: bend1Salvation, weight: 50)
        graph.addEdge(direction: .directed, from: bend1Salvation, to: BW2JunctionSalvation, weight: 50)
        graph.addEdge(direction: .directed, from: BW2JunctionSalvation, to: HOJunctionSalvation, weight: 50)
        graph.addEdge(direction: .undirected, from: HOJunctionSalvation, to: topHO, weight: 1)
        graph.addEdge(direction: .undirected, from: HOJunctionSalvation, to: HOJunctionObsession, weight: 1)
        //Heat's Off
        graph.addEdge(direction: .directed, from: topHO, to: endHO, weight: 50)
//Obsession
        graph.addEdge(direction: .undirected, from: topWHQ, to: topObsession, weight: 1)
        graph.addEdge(direction: .directed, from: topObsession, to: bend1Obsession, weight: 300)
        graph.addEdge(direction: .directed, from: bend1Obsession, to: HOJunctionObsession, weight: 300)
        graph.addEdge(direction: .directed, from: HOJunctionObsession, to: SBJunctionObsession, weight: 300)
        graph.addEdge(direction: .directed, from: SBJunctionObsession, to: bend2Obsession, weight: 300)
        graph.addEdge(direction: .directed, from: bend2Obsession, to: HOnJunctionObsession, weight: 300)
        graph.addEdge(direction: .undirected, from: HOnJunctionObsession, to: obsessionJunctionHON, weight: 1)
        //Chutzpah
        graph.addEdge(direction: .undirected, from: topObsession, to: topChutzpah, weight: 300)
        graph.addEdge(direction: .directed, from: topChutzpah, to: midChutzpah, weight: 4000)
        graph.addEdge(direction: .directed, from: midChutzpah, to: endChutzpah, weight: 4000)
        graph.addEdge(direction: .undirected, from: endChutzpah, to: chutzpahJunctionWH, weight: 1)
        //White Heat
        graph.addEdge(direction: .undirected, from: topWHQ, to: topWH, weight: 1)
        graph.addEdge(direction: .undirected, from: topWH, to: topSW, weight: 1)
        graph.addEdge(direction: .directed, from: topWH, to: chutzpahJunctionWH, weight: 4000)
        graph.addEdge(direction: .directed, from: chutzpahJunctionWH, to: assumptionJunctionWH, weight: 4000)
        graph.addEdge(direction: .undirected, from: assumptionJunctionWH, to: WHJunctionAssumption, weight: 1)
        //Shock Wave
        graph.addEdge(direction: .directed, from: topSW, to: bend1SW, weight: 4000)
        graph.addEdge(direction: .directed, from: bend1SW, to: bend2SW, weight: 4000)
        graph.addEdge(direction: .directed, from: bend2SW, to: assumptionJunctionSW, weight: 4000)
        graph.addEdge(direction: .undirected, from: assumptionJunctionSW, to: SWJunctionAssumption, weight: 1)
        //Tempest
        graph.addEdge(direction: .undirected, from: topTempest, to: topJibe, weight: 1)
        graph.addEdge(direction: .directed, from: topTempest, to: HOJunctionTempest, weight: 300)
        graph.addEdge(direction: .undirected, from: endJibe, to: HOJunctionTempest, weight: 1)
        graph.addEdge(direction: .directed, from: HOJunctionTempest, to: endTempest, weight: 300)
        graph.addEdge(direction: .undirected, from: endTempest, to: botTQ, weight: 1)
        graph.addEdge(direction: .undirected, from: endTempest, to: botLWCQ, weight: 1)
        //Jibe
        graph.addEdge(direction: .directed, from: topJibe, to: bend1Jibe, weight: 50)
        graph.addEdge(direction: .directed, from: bend1Jibe, to: endJibe, weight: 50)
        //Heat's On
        graph.addEdge(direction: .undirected, from: HOJunctionTempest, to: topHON, weight: 1)
        graph.addEdge(direction: .directed, from: topHON, to: obsessionJunctionHON, weight: 50)
        graph.addEdge(direction: .directed, from: obsessionJunctionHON, to: botWHQ, weight: 50)
        graph.addEdge(direction: .directed, from: obsessionJunctionHON, to: assumptionJunctionHON, weight: 50)
        graph.addEdge(direction: .directed, from: assumptionJunctionHON, to: SLJunctionHON, weight: 50)
        //Green Cheese
        graph.addEdge(direction: .undirected, from: topSL, to: topGC, weight: 1)
        graph.addEdge(direction: .directed, from: topGC, to: SBJunctionGC, weight: 1)
        graph.addEdge(direction: .undirected, from: SBJunctionGC, to: GCJunctionSB, weight: 1)
        graph.addEdge(direction: .directed, from: SBJunctionGC, to: endGC, weight: 1)
        graph.addEdge(direction: .directed, from: endGC, to: GCJunctionMS, weight: 1)
        //MoonStruck
        graph.addEdge(direction: .undirected, from: topLWCQ, to: topMS, weight: 1)
        graph.addEdge(direction: .directed, from: topMS, to: bend1MS, weight: 1)
        graph.addEdge(direction: .directed, from: bend1MS, to: bend2MS, weight: 1)
        graph.addEdge(direction: .directed, from: bend2MS, to: bend3MS, weight: 1)
        graph.addEdge(direction: .directed, from: bend3MS, to: GCJunctionMS, weight: 1)
        graph.addEdge(direction: .directed, from: GCJunctionMS, to: bend4MS, weight: 1)
        graph.addEdge(direction: .directed, from: bend4MS, to: SBJunctionMS, weight: 1)
        graph.addEdge(direction: .directed, from: SBJunctionMS, to: SLJunctionMS, weight: 1)
        graph.addEdge(direction: .directed, from: SLJunctionMS, to: endMS, weight: 1)
        graph.addEdge(direction: .undirected, from: endMS, to: botTQ, weight: 1)
        graph.addEdge(direction: .directed, from: endMS, to: botLWCQ, weight: 1)
        //Assumption
        graph.addEdge(direction: .undirected, from: topAssumption, to: topSL, weight: 1)
        graph.addEdge(direction: .directed, from: topAssumption, to: SWJunctionAssumption, weight: 50)
        graph.addEdge(direction: .directed, from: SWJunctionAssumption, to: WHJunctionAssumption, weight: 50)
        graph.addEdge(direction: .directed, from: WHJunctionAssumption, to: WHQJunctionAssumption, weight: 50)
        graph.addEdge(direction: .undirected, from: WHQJunctionAssumption, to: botWHQ, weight: 50)
        graph.addEdge(direction: .directed, from: WHQJunctionAssumption, to: assumptionJunctionHON, weight: 50)
        //Starlight
        graph.addEdge(direction: .directed, from: topLWCQ, to: topSL, weight: 1)
        graph.addEdge(direction: .directed, from: topSL, to: bend1SL, weight: 1)
        graph.addEdge(direction: .directed, from: bend1SL, to: bend2SL, weight: 1)
        graph.addEdge(direction: .directed, from: bend2SL, to: bend3SL, weight: 1)
        graph.addEdge(direction: .directed, from: bend3SL, to: HOJunctionSL, weight: 1)
        graph.addEdge(direction: .undirected, from: HOJunctionSL, to: SLJunctionHON, weight: 1)
        graph.addEdge(direction: .directed, from: HOJunctionSL, to: MSJunctionSL, weight: 1)
        graph.addEdge(direction: .undirected, from: MSJunctionSL, to: SLJunctionMS, weight: 1)
        //Star Struck
        graph.addEdge(direction: .undirected, from: GCJunctionSB, to: topSS, weight: 1)
        graph.addEdge(direction: .directed, from: topSS, to: endSS, weight: 300)
        graph.addEdge(direction: .directed, from: endSS, to: SBJunctionMS, weight: 300)
        //Starwood
        graph.addEdge(direction: .undirected, from: GCJunctionSB, to: topStarW, weight: 1)
        graph.addEdge(direction: .directed, from: topStarW, to: endStarW, weight: 300)
        graph.addEdge(direction: .directed, from: endStarW, to: bend3SL, weight: 300)
        //Starburst
        graph.addEdge(direction: .undirected, from: topLWCQ, to: topStarB, weight: 1)
        graph.addEdge(direction: .directed, from: topStarB, to: GCJunctionSB, weight: 50)
        graph.addEdge(direction: .directed, from: GCJunctionSB, to: endStarB, weight: 50)
        graph.addEdge(direction: .undirected, from: endStarB, to: SBJunctionMS, weight: 1)
        //Little White Cap Quad
//       graph.addEdge(direction: .directed, from: botLWCQ, to: topLWCQ, weight: 100)

    }
    
    static func createAnnotation(title: String?, latitude: Double, longitude: Double, difficulty: Difficulty) -> ImageAnnotation
    {
        let point = ImageAnnotation()
        point.title = title
        point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        point.difficulty = difficulty
        return point
    }
}
