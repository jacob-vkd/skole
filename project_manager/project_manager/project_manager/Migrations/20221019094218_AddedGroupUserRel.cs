using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace project_manager.Migrations
{
    public partial class AddedGroupUserRel : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_GroupsUsers",
                table: "GroupsUsers");

            migrationBuilder.DropIndex(
                name: "IX_GroupsUsers_GroupId",
                table: "GroupsUsers");

            migrationBuilder.AlterColumn<int>(
                name: "GroupUserId",
                table: "GroupsUsers",
                type: "INTEGER",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "INTEGER")
                .OldAnnotation("Sqlite:Autoincrement", true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_GroupsUsers",
                table: "GroupsUsers",
                columns: new[] { "GroupId", "UserId" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_GroupsUsers",
                table: "GroupsUsers");

            migrationBuilder.AlterColumn<int>(
                name: "GroupUserId",
                table: "GroupsUsers",
                type: "INTEGER",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "INTEGER")
                .Annotation("Sqlite:Autoincrement", true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_GroupsUsers",
                table: "GroupsUsers",
                column: "GroupUserId");

            migrationBuilder.CreateIndex(
                name: "IX_GroupsUsers_GroupId",
                table: "GroupsUsers",
                column: "GroupId");
        }
    }
}
