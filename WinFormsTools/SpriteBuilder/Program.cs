using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpriteBuilder
{
    class Program
    {
        const int CellWidth = 8;
        static int Main(string[] args)
        {
            Image srcImage;
            int cellCount;
            int foreColor;
            int backColor;
            string outPath;

            if(ParseArgs(args, out srcImage, out cellCount, out foreColor, out backColor, out outPath) == false)
                return 1;

            var bitMap = new Bitmap(srcImage);
            var foreChar = foreColor.ToString()[0];
            var backChar = backColor.ToString()[0];

            Console.WriteLine("Writing to " + Path.GetFullPath(outPath));
            using (var writer = new StreamWriter(outPath))
            {
                for (int cell = 0; cell < cellCount; cell++)
                {
                    WriteSprite(writer, bitMap, cell, foreChar, backChar);
                }

                writer.WriteLine(string.Format("; {0} last updated {1} UTC", Path.GetFileName(outPath), DateTime.UtcNow));
            }

            return 0;
        }

        static void WriteSprite(StreamWriter writer, Bitmap bitMap, int cell, char foreChar, char backChar)
        {
            writer.WriteLine(string.Format("; cell {0}", cell));

            var xStart = cell * CellWidth;
            var xEnd = (cell + 1) * CellWidth;
            for (int y = 0; y < CellWidth; y++)
            {
                writer.Write("dw `");
                for (int x = xStart; x < xEnd; x++)
                {
                    if(bitMap.GetPixel(x, y).A > 0)
                        writer.Write(foreChar);
                    else
                        writer.Write(backChar);
                }
                writer.WriteLine();
            }
            writer.WriteLine();
        }

        static bool ParseArgs(string[] args, out Image srcImage, out int cellCount, out int foreColor, out int backColor, out string ouputPath)
        {
            try
            {
                srcImage = Image.FromFile(args[0]);
                cellCount = int.Parse(args[1]);
                foreColor = int.Parse(args[2]);
                backColor = int.Parse(args[3]);
                ouputPath = args[4];

                if (foreColor > 3)
                    throw new IndexOutOfRangeException("forecolor can only be 0 to 3");
                if (backColor > 3)
                    throw new IndexOutOfRangeException("backColor can only be 0 to 3");

                return true;
            }
            catch(Exception e)
            {
                Console.Write("ARGS: SRC.PNG FOREGROUND BACKGROUND OUT.ASM\n" + e);

                srcImage = null;
                cellCount = 0;
                foreColor = 0;
                backColor = 0;
                ouputPath = null;
                return false;
            }
        }
    }
}
