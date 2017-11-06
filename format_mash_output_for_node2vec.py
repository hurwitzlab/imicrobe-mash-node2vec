"""
Format MASH output as an adjacency list for node2vec.

MASH output looks like this:
#query file_1 file_2 ... file_N
file_1  0.0    0.9   ... 0.1
file_2  0.9    0.8   ... 0.2
...     ...    ...   ... ...
file_N  0.8    0.7   ... 0.0

"""
import argparse
import itertools
import os
import sys

import pandas as pd


def get_args(argv):
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('mash_output_fp',
                            help='file path to MASH output')
    arg_parser.add_argument('--limit', type=int, default=None,
                            help='use only the first <limit> rows and columns of the MASH output')
    arg_parser.add_argument('--distance', action='store_true', default=False,
                            help='output MASH distance rather than similarity (1.0 - distance)')

    args = arg_parser.parse_args(args=argv)
    return args


def main():
    args = get_args(sys.argv[1:])

    sys.stderr.write('reading "{}"\n'.format(args.mash_output_fp))

    with open(args.mash_output_fp, 'rt') as mash_output_file:
        mash_output_file.read(len('#query '))
        all_vs_all_df = pd.read_table(filepath_or_buffer=mash_output_file)
        sys.stderr.write('shape of "{}" is {}\n'.format(args.mash_output_fp, all_vs_all_df.shape))


    input_file_name = os.path.basename(args.mash_output_fp)
    input_basename, input_ext = os.path.splitext(input_file_name)
    output_fp = input_basename \
              + ('_distance' if args.distance else '_similarity') \
              + ('_limit_{}'.format(args.limit) if args.limit else '') \
              + '.edgelist'

    sys.stderr.write('writing file "{}"\n'.format(output_fp))

    edge_count = 0
    eliminated_edge_count = 0
    with open(output_fp, 'wt') as output_file:
        for i, j in itertools.combinations(all_vs_all_df.index[:args.limit], r=2):
            # i and j look like
            #   /work/05066/imicrobe/iplantc.org/data/imicrobe/projects/193/samples/4078/mgm4601014.3.050.upload.fna
            mash_distance = all_vs_all_df.loc[i, j]
            if mash_distance >= 1.0:
                eliminated_edge_count += 1
            else:
                edge_count += 1
                i_sample_id = int(os.path.basename(os.path.dirname(i)))
                j_sample_id = int(os.path.basename(os.path.dirname(j)))
                if args.distance:
                    output_file.write('{} {} {:8.6f}\n'.format(i_sample_id, j_sample_id, mash_distance))
                else:
                    # similarity
                    output_file.write('{} {} {:8.6f}\n'.format(i_sample_id, j_sample_id, 1.0 - mash_distance))

    print('edge count: {}'.format(edge_count))
    print('eliminated {} edges'.format(eliminated_edge_count))


if __name__ == '__main__':
    main()
