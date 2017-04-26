//
//  ViewController.swift
//  CityGuide
//
//  Created by Florian Fittschen on 11/09/15.
//  Copyright © 2015 TUM LS1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityTextView: UITextView!
    
    private let hamburg = City(
        name: "Hamburg",
        imageName: "Hamburg",
        guide: "Hamburg, officially Freie und Hansestadt Hamburg (Free and Hanseatic City of Hamburg), is the second largest city in Germany and the eighth largest city in the European Union. It is also the thirteenth largest German state. Its population is over 1.7 million people, and the Hamburg Metropolitan Region (including parts of the neighbouring Federal States of Lower Saxony and Schleswig-Holstein) has more than 5 million inhabitants. The city is situated on the river Elbe. The official name reflects its history as a member of the medieval Hanseatic League, as a free imperial city of the Holy Roman Empire, a city-state, and one of the 16 states of Germany. Before the 1871 Unification of Germany, it was a fully sovereign state. Prior to the constitutional changes in 1919, the stringent civic republic was ruled by a class of hereditary grand burghers or Hanseaten. Hamburg is a transport hub and is an affluent city in Europe. It has become a media and industrial centre, with plants and facilities belonging to Airbus, Blohm + Voss and Aurubis. The radio and television broadcaster Norddeutscher Rundfunk and publishers such as Gruner + Jahr and Spiegel-Verlag are pillars of the important media industry in Hamburg. Hamburg has been an important financial centre for centuries, and is the seat of the world's second oldest bank, Berenberg Bank. The city is a notable tourist destination for both domestic and overseas visitors; it ranked 16th in the world for livability in 2015. The Speicherstadt was declared a World Heritage Site by the UNESCO in July 2015.",
        favorite: true)
    
    private let munich = City(
        name: "Munich",
        imageName: "Munich",
        guide: "Munich is the capital and largest city of the German state of Bavaria, on the banks of River Isar north of the Bavarian Alps. Munich is the third largest city in Germany, after Berlin and Hamburg, with a population of around 1.5 million. The Munich Metropolitan Region is home to 5.8 million people. The name of the city is derived from the Old/Middle High German term Munichen, meaning 'by the monks'. It derives from the monks of the Benedictine order who ran a monastery at the place that was later to become the Old Town of Munich; hence the monk depicted on the city's coat of arms. Munich was first mentioned in 1158. From 1255 the city was seat of the Bavarian Dukes. Black and gold — the colours of the Holy Roman Empire — have been the city's official colours since the time of Ludwig the Bavarian, when it was an imperial residence. Following a final reunification of the Wittelsbachian Duchy of Bavaria, previously divided and sub-divided for more than 200 years, the town became the country's sole capital in 1506. Catholic Munich was a cultural stronghold of the Counter-Reformation and a political point of divergence during the resulting Thirty Years' War, but remained physically untouched despite an occupation by the Protestant Swedes; as the townsfolk would rather open the gates of their town than risk siege and almost inevitable destruction. Like wide parts of the Holy Roman Empire, the area recovered slowly economically. Having evolved from a duchy's capital into that of an electorate (1623), and later a sovereign kingdom (1806), Munich has been a centre of arts, culture and science since the early 19th century. The city became the Nazi movement's infamous Hauptstadt der Bewegung (lit.: 'Capital of the movement'), and after post-war reconstruction was the host city of the 1972 Summer Olympics.",
        favorite: true)
    
    private let cologne = City(
        name: "Cologne",
        imageName: "Cologne",
        guide: "Cologne, Germany's fourth-largest city (after Berlin, Hamburg, and Munich), is the largest city both in the German Federal State of North Rhine-Westphalia and within the Rhine-Ruhr Metropolitan Area, one of the major European metropolitan areas with more than ten million inhabitants. Cologne is located on both sides of the Rhine River, fewer than eighty kilometers from Belgium. The city's famous Cologne Cathedral (Kölner Dom) is the seat of the Catholic Archbishop of Cologne. The University of Cologne (Universität zu Köln) is one of Europe's oldest and largest universities. Cologne was founded and established in Ubii territory in the first century AD as the Roman Colonia Claudia Ara Agrippinensium, from which it gets its name. 'Cologne', the French version of the city's name, has become standard in English as well. The city functioned as the capital of the Roman province of Germania Inferior and as the headquarters of the Roman military in the region until occupied by the Franks in 462. During the Middle Ages it flourished on one of the most important major trade routes between east and west in Europe. Cologne was one of the leading members of the Hanseatic League and one of the largest cities north of the Alps in medieval and Renaissance times. Up until World War II the city had undergone several occupations by the French and also by the British (1918-1926). Cologne was one of the most heavily-bombed cities in Germany during World War II, the Royal Air Force (RAF) dropping 34,711 long tons of bombs on the city. The bombing reduced the population by 95%, mainly due to evacuation, and destroyed almost the entire city. With the intention of restoring as many historic buildings as possible, the successful postwar rebuilding has resulted in a very mixed and unique cityscape.",
        favorite: false)
    
    private let berlin = City(
        name: "Berlin",
        imageName: "Berlin",
        guide: "Berlin is the capital of Germany and one of the 16 states of Germany. With a population of 3.5 million people, Berlin is Germany's largest city. It is the second most populous city proper and the seventh most populous urban area in the European Union. Located in northeastern Germany on the banks of Rivers Spree and Havel, it is the centre of the Berlin-Brandenburg Metropolitan Region, which has about six million residents from over 180 nations. Due to its location in the European Plain, Berlin is influenced by a temperate seasonal climate. Around one-third of the city's area is composed of forests, parks, gardens, rivers and lakes. First documented in the 13th century, Berlin became the capital of the Margraviate of Brandenburg (1417-1701), the Kingdom of Prussia (1701–1918), the German Empire (1871–1918), the Weimar Republic (1919–1933) and the Third Reich (1933–1945). Berlin in the 1920s was the third largest municipality in the world. After World War II, the city was divided; East Berlin became the capital of East Germany while West Berlin became a de facto West German exclave, surrounded by the Berlin Wall (1961–1989). Following German reunification in 1990, Berlin was once again designated as the capital of all Germany. Berlin is a world city of culture, politics, media, and science. Its economy is based on high-tech firms and the service sector, encompassing a diverse range of creative industries, research facilities, media corporations, and convention venues. Berlin serves as a continental hub for air and rail traffic and has a highly complex public transportation network. The metropolis is a popular tourist destination. Significant industries also include IT, pharmaceuticals, biomedical engineering, clean tech, biotechnology, construction, and electronics.",
        favorite: false)
    
    private let frankfurt = City(
        name: "Frankfurt",
        imageName: "Frankfurt",
        guide: "Frankfurt am Main is the largest city in the German state of Hesse and the fifth-largest city in Germany, with a 2014 population of 714,241 within its administrative boundaries. The urban area called Frankfurt Rhein-Main has a population of 2,221,910. The city is at the centre of the larger Frankfurt Rhine-Main Metropolitan Region which has a population of 5,500,000 and is Germany's second-largest metropolitan region. Since the enlargement of the European Union in 2013, the geographic centre of the EU is about 40 km (25 mi) to the east. Frankfurt is a centre for commerce, culture, education, tourism and web traffic. Messe Frankfurt is one of the world's largest trade fairs at 578,000 square metres and ten exhibition halls. Major trade fairs include the Frankfurt Motor Show, the world's largest motor show, and the Frankfurt Book Fair, the world's largest book fair. Frankfurt is home to many cultural and educational institutions, including the Johann Wolfgang Goethe University and Frankfurt University of Applied Sciences, many museums (e.g. Städel, Naturmuseum Senckenberg, Schirn Kunsthalle Frankfurt, Goethe House) and two major botanical gardens, the Palmengarten, which is Germany's largest, and the Botanical Garden of Goethe University.",
        favorite: false)
    
    private let bremen = City(
        name: "Bremen",
        imageName: "Bremen",
        guide: "The City Municipality of Bremen is a Hanseatic city in northwestern Germany. A commercial and industrial city with a major port on the River Weser, Bremen is part of the Bremen/Oldenburg Metropolitan Region (2.4 million people). Bremen is the second most populous city in Northern Germany and tenth in Germany. Bremen is a major cultural and economic hub in the northern regions of Germany. Bremen is home to dozens of historical galleries and museums, ranging from historical sculptures to major art museums, such as the Übersee-Museum Bremen. Bremen has a reputation as a working class city. Along with this, Bremen is home to a large number of multinational companies and manufacturing centers. Companies headquartered in Bremen include the Hachez chocolate company and Vector Foiltec. Bremen is some 60 km (37 mi) south from the Weser mouth on the North Sea. With Bremerhaven right on the mouth the two comprise the state of the Free Hanseatic City of Bremen (official German name: Freie Hansestadt Bremen).",
        favorite: false)
    
    fileprivate var cities: [City]!
    fileprivate var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cities = [hamburg, munich, cologne, berlin, frankfurt, bremen]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
    }
    
    fileprivate func updateView() {
        if let image = UIImage(named: cities[currentIndex].imageName) {
            title = cities[currentIndex].composedName
            cityImageView.image = image
            cityTextView.text = cities[currentIndex].guide
            cityTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        }
    }

    @IBAction func didPressNext(_ sender: UIButton) {
        currentIndex = (currentIndex + 1) % cities.count
        updateView()
    }

}
