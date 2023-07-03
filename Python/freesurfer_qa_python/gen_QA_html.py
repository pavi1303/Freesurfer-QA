import os
import sys


def create_html_qa(qa_ss_dir):
    global os
    sublist = [sub.name for sub in os.scandir(qa_ss_dir) if sub.is_dir()]
    for sub in sublist:
        html_filename = f"QA_{sub}.html"
        html_savepath = os.path.join(os.path.dirname(qa_ss_dir), 'QA_html')
        if not os.path.exists(html_savepath):
            os.makedirs(html_savepath)
        html_savename = os.path.join(html_savepath, html_filename)
        with open(html_savename, "w") as html_file:
            html_file.write(f"""
                            <html>
                            <head>
                            <title>QA_{sub}</title>
                            <style>
                            img {{
                                display: block;
                                margin-left: auto;
                                margin-right: auto;
                            }}
                            p {{
                                text-align: center;
                            }}
                            </style>
                            </head>
                            <body>
                        """)

            subfolder = [folder.name for folder in os.scandir(os.path.join(qa_ss_dir, sub)) if folder.is_dir()]

            for folder in subfolder:
                pnglist = [png for png in sorted(os.listdir(os.path.join(qa_ss_dir, sub, folder)),
                                                 key=lambda x: int(x.split('-')[-1].split('.')[0]) if x.split('-')[-1].split('.')[0].isdigit()
                                                 else float('inf')) if png.endswith('.png')]

                import os

                if len(pnglist) == 0:
                    continue

                html_file.write(f"<h2>{folder}</h2>\n")

                row_limit = 4
                num_rows = (len(pnglist) + row_limit - 1) // row_limit

                for row in range(num_rows):
                    html_file.write("<table>\n")
                    html_file.write("<tr>\n")

                    start_idx = row * row_limit
                    end_idx = min(start_idx + row_limit, len(pnglist))

                    for idx in range(start_idx, end_idx):
                        png_file = pnglist[idx]
                        png_path = os.path.join(qa_ss_dir, sub, folder, png_file)
                        filename = os.path.splitext(png_file)[0]
                        html_file.write(f"""
                                            <td>
                                            <a href='{png_path}'><img src='{png_path}' width='500'></a>
                                            <p>{filename}</p>
                                            </td>
                                        """)

                    html_file.write("</tr>\n</table>\n<br>\n")

            html_file.write("</body>\n</html>\n")


ss_dir = r'W:\ADRC_QA\v1\fs_output_07032023\QA_results_07032023\QA_screenshots'
create_html_qa(ss_dir)
