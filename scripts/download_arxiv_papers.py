import os
import urllib.request
import urllib.parse
import xml.etree.ElementTree as ET
import time

DOMAINS = {
    "random_walk": "Galton-Watson branching process random walk",
    "revops_turbulence": "turbulence phase transitions statistical mechanics",
    "star_graphs": "star graph topology betti numbers",
    "pair_correlation": "stochastic pair correlation function",
    "scalar_dissipation": "scalar dissipation rate metric spaces",
    "quantum_hall": "quantum hall effect topological edge states",
    "smfdcca": "multifractal detrended cross-correlation analysis",
    "sparse_chaos_diagnostic": "sparse chaos diagnostics lyapunov exponents",
    "terminal_breakdown": "failure cascades directed acyclic graphs",
    "weighted_random_networks": "weighted random networks degree distribution",
    "combinatorial_topology": "simplicial complexes cell complexes combinatorial topology",
    "hyperdimensional_cognitive": "hyperdimensional computing orthogonal vectors",
    "minimal_measures": "invariant minimal measures dynamical systems",
    "ortac_plus": "differential topology invariants automated boundaries",
    "signal_criticality": "critical slowing down complex systems",
    "bio_signals": "physiological oscillations heartbeat models"
}

BASE_URL = "http://export.arxiv.org/api/query?search_query=all:{query}&start=0&max_results=1"

for folder, query in DOMAINS.items():
    print(f"Fetching arXiv for {folder}...")
    encoded_query = urllib.parse.quote(query)
    url = BASE_URL.format(query=encoded_query)
    
    try:
        response = urllib.request.urlopen(url)
        xml_data = response.read()
        root = ET.fromstring(xml_data)
        
        # arXiv atom namespace
        ns = {'atom': 'http://www.w3.org/2005/Atom'}
        entry = root.find('atom:entry', ns)
        
        if entry is not None:
            title = entry.find('atom:title', ns).text.replace('\n', ' ').strip()
            pdf_link = None
            for link in entry.findall('atom:link', ns):
                if link.attrib.get('title') == 'pdf':
                    pdf_link = link.attrib.get('href')
                    break
            
            if pdf_link:
                # Ensure directory exists
                target_dir = f"/Users/sac/mfact/research-papers/{folder}"
                os.makedirs(target_dir, exist_ok=True)
                
                pdf_path = os.path.join(target_dir, "arxiv_reference.pdf")
                
                print(f"  Found: {title}")
                print(f"  Downloading PDF to {pdf_path}...")
                
                # Download PDF
                urllib.request.urlretrieve(pdf_link, pdf_path)
                
                # Save metadata
                meta_path = os.path.join(target_dir, "arxiv_metadata.txt")
                with open(meta_path, 'w') as f:
                    f.write(f"Title: {title}\n")
                    f.write(f"URL: {pdf_link}\n")
                    f.write(f"Query: {query}\n")
                    
                print(f"  Success for {folder}.")
            else:
                print(f"  No PDF link found for {folder}.")
        else:
            print(f"  No results found for {folder}.")
            
    except Exception as e:
        print(f"  Error fetching {folder}: {e}")
    
    time.sleep(3) # Be nice to arXiv API
