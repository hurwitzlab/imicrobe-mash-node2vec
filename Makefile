install:
	pip install -r requirements.txt

test-100-node-edgelist:
	python format_mash_output_for_node2vec.py /usr/local/imicrobe/mash-all-vs-all/all-imicrobe-dist.txt --limit 100

node2vec-test:
	~/build/snap/examples/node2vec/node2vec -i:all-imicrobe-dist_similarity_limit_100.edgelist -o:all-imicrobe-dist_similarity_limit_100.emb -w -v

py-node2vec-test:
	node2vec --input all-imicrobe-dist_similarity_limit_100.edgelist --output all-imicrobe-dist_similarity_limit_100.emb --weighted

all-vs-all-edgelist:
	python format_mash_output_for_node2vec.py /usr/local/imicrobe/mash-all-vs-all/all-imicrobe-dist.txt

py-node2vec:
	node2vec --input all-imicrobe-dist_similarity.edgelist --output all_imicroabe_similarity.emb --weighted

lytic-rsync-dry-run:
	rsync -n -arvzP --delete --exclude-from=rsync.exclude -e "ssh -A -t hpc ssh -A -t lytic" ./ :project/imicrobe/imicrobe-mash-node2vec

lytic-rsync:
	rsync -arvzP --delete --exclude-from=rsync.exclude -e "ssh -A -t hpc ssh -A -t lytic" ./ :project/imicrobe/imicrobe-mash-node2vec
